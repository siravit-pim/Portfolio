## Calculate_Area

import tkinter as tk #python3
try:
    from Tkinter import * #maybe python2
except ImportError:    
    from tkinter import *

root = tk.Tk()

# title windows
root.title('Welcome to Calculator Area')

# setting window size
root.geometry('250x100')

# label (text)
l1 = Label(root, text="Enter width : ").grid(row=1)
l2 = Label(root, text="Enter height : ").grid(row=2)

# create entry for calculate
e1 = tk.Entry()
e1.grid(row=1, column=1)
e2 = tk.Entry()
e2.grid(row=2, column=1)

# label result
result = Label(root, text='')
result.grid(row=3, column=1)

# --------------------------------
def areaCal():
    #global result
    width = int(e1.get())
    height = int(e2.get())
    area = width * height
    result.config(text=area)

# create button
button = tk.Button(root, text='Calculate !',command=areaCal).grid(row=4, column=1)

root.mainloop()
