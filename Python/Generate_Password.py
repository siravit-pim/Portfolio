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
