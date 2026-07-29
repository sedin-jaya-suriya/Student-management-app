class ReportCardGenerator
  def self.call(student)
    pdf = Prawn::Document.new

    pdf.text "ABC Academy"
    pdf.move_down 10

    pdf.text "Report Card"
    pdf.move_down 10

    pdf.text "Name: #{student.name}"
    pdf.text "Email: #{student.email}"
    pdf.text "Course: #{student.course}"
    pdf.text "Marks: #{student.marks}"
    pdf.text "Total: 100"
    pdf.text "Percentage: #{student.marks}%"
    pdf.text "Result: #{student.result}"

    pdf.render
  end
end
