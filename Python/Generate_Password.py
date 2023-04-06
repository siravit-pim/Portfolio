# Can use 2 Version, result same.
# Generate Password from Character / Number / Punctuation
import random
import string

t1 = string.digits 
t2 = string.ascii_letters
t3 = string.ascii_letters + string.digits 
t4 = string.ascii_letters + string.digits + string.punctuation

def generate_pass() :
    while True:     
        length = int(input('Input your length do you want: '))
        print("1: Number \n2: Character \n3: Number + Character \n4: Number + Character + Punctuation")
        typepass = int(input('Input your type password do you want: '))

        if typepass == 1 :
            passw = random.choices(t1, k=length)
            passw = "".join(passw)
        elif typepass == 2 :
            passw = random.sample(t2,length)
            passw = "".join(passw)
        elif typepass == 3 :
            passw = random.sample(t3,length)
            passw = "".join(passw)
        elif typepass == 4 :
            passw = random.sample(t4,length)
            passw = "".join(passw) 
        else :
            print('That Worng !! \nPls try again :D')
            passw = None
        print("Your password : ",passw)
        
        print("1.Yes \n2.No")
        if int(input("You want to try again ? : ")) == 2:
            break
            
generate_pass()
#---------------------------------------------------------
#---------------------------------------------------------
#---------------------------------------------------------

# Generate Password from Character / Number / Punctuation
import random
import string

def passGenerator(length, choice) :  
    if choice == 1 :
        t = string.digits 
        passw = random.sample(t,length)        
        passw = "".join(passw)
    elif choice == 2 :
        t = string.ascii_letters
        passw = random.sample(t,length)
        passw = "".join(passw)
    elif choice == 3 :
        t = string.ascii_letters + string.digits 
        passw = random.sample(t,length)
        passw = "".join(passw)
    elif choice == 4 :
        t = string.ascii_letters + string.digits + string.punctuation
        passw = random.sample(t,length)
        passw = "".join(passw) 
    else :
        print('Worng')
        passw = None 
    return(passw)

while(True) :
    length = int(input('input your length do you want : '))
    choice = int(input('input your type password do you want : '))
    genated = passGenerator(length,choice)
    print("Your Pass : ",genated)
    checker = int(input("wanna geralate again: [y/n]"))
    if checker == 1 :
        break
#---------------------------------------------------------
#---------------------------------------------------------
#---------------------------------------------------------
# With Tkinter
import random
import string
import tkinter as tk
import pyperclip as pc

def generate():
    entry.delete(0, tk.END)
    length = lengthInput.get()
    
    lower = string.ascii_lowercase
    upper = string.ascii_uppercase
    num = string.digits
    symbol = string.punctuation
    
    lowC = lower+upper
    mediumC = lower+upper+num
    strongC = lower+upper+num+symbol
    password = ""
    
    if strengthInput.get() == 0:
        for i in range(length):
            password = password + random.choice(lowC)
    elif strengthInput.get() == 1:
         for i in range(length):
            password = password + random.choice(mediumC)
    elif strengthInput.get() == 2:
         for i in range(length):
            password = password + random.choice(strongC)  
    entry.insert(0, password)
    
def copy():
    randomPassword = entry.get()
    pc.copy(randomPassword)

root = tk.Tk()
lengthInput = tk.IntVar()
strengthInput = tk.IntVar()

root.title("Random Password Generator")

lengthLabel = tk.Label(root, text = "Preferred Lenght").grid(row=0, column=0)
lengthBox = tk.Spinbox(root, from_ = 4, to = 10, textvariable = lengthInput).grid(row=0, column=1)

strengthLabel = tk.Label(root, text = "Preferred Strength").grid(row=0, column=2)
strengthLow = tk.Radiobutton(root, text = "Low", variable = strengthInput, value = 0).grid(row=0, column=3)
strengthMedium = tk.Radiobutton(root, text = "Medium", variable = strengthInput, value = 1).grid(row=0, column=4)
strengthStrong = tk.Radiobutton(root, text = "Strong", variable = strengthInput, value = 2).grid(row=0, column=5)

randomPassword = tk.Label(root, text = "Password").grid(row=1, column=0)
entry = tk.Entry(root)
entry.grid(row=1, column=1)

generateBotton = tk.Button(root, text = "Generate", command = generate).grid(row=1, column=2)
copyBotton = tk.Button(root, text = "Copy",command = copy).grid(row=1, column=3)

root.mainloop()
quit()
