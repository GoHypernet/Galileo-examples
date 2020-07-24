import time, sys

print("Short python example...")
print("I will write a file for you see how results are returned :)") 
sys.stdout.flush()

time.sleep(10)

f = open("example_output.txt", "a")
f.write("Hello World!")
f.close()