import random

n = int(input()) + 4
color_list = []
k = 0x10 # color constant
for i in range(n):
    color_list.append(k+i*2)
print(color_list)
key = []
pre_key = []
while len(pre_key) < n:
    j = random.randrange(0,n)
    if j not in pre_key:
        pre_key.append(j)
i = 0
for item in pre_key:
    if i < 4:
        key.append(color_list[item])
    i += 1

print(key)

for k in range(10):
    num_right = 0
    num_half = 0
    guess = []
    for i in range(4):
        guess.append(color_list[int(input())])
        if guess[i] == key[i]:
            num_right += 1
        elif guess[i] in key:
            num_half += 1
    print(guess)
    print("pinos pretos:", num_right)
    print("pinos brancos:", num_half)