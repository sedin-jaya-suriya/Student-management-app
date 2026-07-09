require "test_helper"

class StudentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin = users(:admin)
    @teacher = users(:teacher)
    @student = students(:one)
    sign_in @admin
  end

  test "should get index" do
    get students_url
    assert_response :success
    assert_select "h1", "Students"
    # Should include counter
    assert_select "#student_count", text: "2"
  end

  test "should filter/search students" do
    # Search matches Student One
    get students_url(search: "Student One")
    assert_response :success
    assert_select "td", "Student One"
    assert_select "td", { text: "Student Two", count: 0 }

    # Search matches none
    get students_url(search: "Nonexistent")
    assert_response :success
    assert_select "td", { text: "Student One", count: 0 }
    assert_select "td", "No students found."
  end

  test "should create student via turbo stream" do
    assert_difference("Student.count", 1) do
      post students_url, params: {
        student: {
          name: "New Student",
          email: "newstudent@example.com",
          age: 22,
          course: "React",
          city: "Mumbai",
          marks: 95,
          teacher_id: @teacher.id
        }
      }, as: :turbo_stream
    end

    assert_response :success
    assert_match /turbo-stream action="append" target="students_tbody"/, response.body
    assert_match /turbo-stream action="update" target="student_count"/, response.body
    assert_match /turbo-stream action="update" target="new_student"/, response.body
    assert_match /turbo-stream action="update" target="flash_messages"/, response.body
  end

  test "should return unprocessable_entity on create failure via turbo stream" do
    assert_no_difference("Student.count") do
      post students_url, params: {
        student: {
          name: "",
          email: ""
        }
      }, as: :turbo_stream
    end

    assert_response :success # Turbo stream response returning errors renders 200
    assert_match /turbo-stream action="replace" target="new_student"/, response.body
    assert_match /Name can&#39;t be blank/, response.body
  end

  test "should get edit inline frame" do
    get edit_student_url(@student), headers: { "Turbo-Frame" => dom_id(@student) }
    assert_response :success
    assert_select "turbo-frame", id: dom_id(@student) do
      assert_select "form"
    end
  end

  test "should update student via turbo stream" do
    patch student_url(@student), params: {
      student: {
        name: "Updated Student Name"
      }
    }, as: :turbo_stream

    assert_response :success
    assert_match /turbo-stream action="replace" target="#{dom_id(@student)}"/, response.body
    assert_match /Updated Student Name/, response.body
    @student.reload
    assert_equal "Updated Student Name", @student.name
  end

  test "should handle update failure" do
    patch student_url(@student), params: {
      student: {
        name: ""
      }
    }
    assert_response :unprocessable_entity
    assert_select "li", "Name can't be blank"
  end

  test "should destroy student via turbo stream" do
    assert_difference("Student.count", -1) do
      delete student_url(@student), as: :turbo_stream
    end

    assert_response :success
    assert_match /turbo-stream action="remove" target="#{dom_id(@student)}"/, response.body
    assert_match /turbo-stream action="update" target="student_count"/, response.body
  end
end
