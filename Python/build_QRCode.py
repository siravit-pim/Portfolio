# pip install qrcode
import qrcode

link = input("")
qr = qrcode.QRCode(version = 1, box_size = 10, border =2)
qr.add_data(link)
qr.make(fit = True)
img = qr.make_image(fill_color = "black", back_color = "white")

img.save("qrCode.png")

# ----------------------------
# check path
#import os
#os.getcwd()
