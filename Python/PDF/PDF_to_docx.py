## PDF to Docx
# pip install pdf2docx
from pdf2docx import Converter

pdfFile = "book1.pdf"
docxFile = "test_docx.docx"

cv = Converter(pdfFile)
cv.convert(docxFile)
