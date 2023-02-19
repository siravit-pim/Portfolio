## PDF File Merging
# pip install PyPDF4
import PyPDF4

def PDFMerger(pdfs, pdfCombined):
    pdfMerger = PyPDF4.PdfFileMerger()

    for pdf in pdfs :
        pdfMerger.append(pdf)
    
    newFile = open(pdfCombined, 'wb')
    pdfMerger.write(newFile)
    newFile.close()
    print("Done !")

# defind 2 file and combined file name
pdfs = ['test_PDF1.pdf','test_PDF2.pdf']
pdfCombined = 'combined_test_PDF.pdf'

PDFMerger(pdfs, pdfCombined)
