## Face Detection for image
#pip install opencv-python
import cv2

imagePath = "11.jpg"
face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades+"haarcascade_frontalface_default.xml")

image = cv2.imread(imagePath)
grayScaleImage = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
detectedFace = face_cascade.detectMultiScale(grayScaleImage)

for x,y,w,h in detectedFace:
    image = cv2.rectangle(image, (x,y), (x+w, y+h), (0, 255, 0), 2)
    cv2.imshow("Face Detection", image)
    cv2.waitKey(1000)

while True:
    if cv2.waitKey(1) & 0xFF == ord("q"):
        break
cv2.destroyAllWindows()
quit()
