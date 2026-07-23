class ReportCardGenerator
  def self.call(student)
    pdf = Prawn::Document.new

    pdf.text "ABC Academy"
    pdf.move_down 10

    pdf.text "Report Card"
    pdf.move_down 10

    pdf.text "Name: #{student.name}"
    pdf.text "Course: #{student.course}"
    pdf.text "Marks: #{student.marks}"
    pdf.text "Result: #{student.result}"

    pdf_data = pdf.render

    student.report_card.attach(
      io: StringIO.new(pdf_data),
      filename: "ReportCard_#{student.id}.pdf",
      content_type: "application/pdf"
    )
  end
end
