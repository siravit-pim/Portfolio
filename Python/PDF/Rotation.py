# pip install PyPDF4
import PyPDF4

## PDF File Rotation
def PDFRotation(originalFileName, newFileName, rotateAngle) :
    pdfReader = PyPDF4.PdfFileReader(originalFileName)
    pdfWriter = PyPDF4.PdfFileWriter()

    # if more than 1 page
    for page in range(pdfReader.getNumPages()):
        pageObject = pdfReader.getPage(page)
        pageObject.rotateClockwise(rotateAngle)
        pdfWriter.addPage(pageObject)

    newFile = open(newFileName, "wb")
    pdfWriter.write(newFile)
    newFile.close()
    print("Done !")

# Define original file and rotation file name
originalFileName = "test_PDF.pdf"
newFileName = "Rotation_test_PDF.pdf"
rotateAngle = 90

PDFRotation(originalFileName, newFileName, rotateAngle)
