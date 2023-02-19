## Face Detection with cemera (real time)
#pip install opencv-python
import cv2

videoCapture = cv2.VideoCapture(0) # each cemera (0) 
#videoCapture = cv2.VideoCapture("test_dectect.mp4") # with Vedio
face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades+"haarcascade_frontalface_default.xml")

while True:
    ret, frames = videoCapture.read()
    if not ret:
        print("Error: failed to read frame")
        break
    grayScaleFrame = cv2.cvtColor(frames, cv2.COLOR_BGR2GRAY)
    detectedFace = face_cascade.detectMultiScale(grayScaleFrame)
    for x,y,w,h in detectedFace:
        cv2.rectangle(frames, (x,y), (x+w, y+h), (0, 255, 0), 2)
    cv2.imshow("Video Face Detection", frames)
    if cv2.waitKey(1) & 0xFF == ord("q"):
        break
        
videoCapture.release()
cv2.destroyAllWindows()
