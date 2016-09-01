# Shao Depeng 20150813 v0.1
# c_dshao@qti.qualcomm.com

#! /usr/bin/env python
import sys
import getopt

in_file = ""
out_file = ""
split_num = 10

def Usage():
#	print("%s -i input -o output -n split_num" %sys.argv[0])
	print("%s -i input -n split_num" %sys.argv[0])
	print("via '%s -h' to get help" %sys.argv[0])

def ParseParms():
    global in_file
    global out_file
    global split_num

    #opts, args = getopt.getopt(sys.argv[1:], "hi:o:n:")
    opts, args = getopt.getopt(sys.argv[1:], "hi:n:")
    for op, value in opts:
        if (op == "-i"):
            in_file = value
#       elif (op == "-o"):
#            out_file = value
        elif (op == "-n"):
            split_num = int(value)
        elif (op == "-h"):
            Usage()
            sys.exit()

    if (in_file == ""):
        print ("input file is null")
        Usage()
        sys.exit()
#    elif (out_file == ""):
#        print ("output file is null")
        Usage()
        sys.exit()
    else:
#       print ("input:%s, output:%s, split_num:%d" %(in_file, out_file, split_num))
        print ("input:%s, split_num:%d" %(in_file, split_num))

def LineCount(file_object):
    count = 0
    while True:
        buf = file_object.read(8192*1024)
        if (not buf):
            break
        count += buf.count('\n')

    return count

def Main():
    global in_file
    global out_file
    global split_num
    loop = 0
    ref_line = 0

    ParseParms()

    in_object = open(in_file)

    in_count = LineCount(in_object)

    ecah_count = int(in_count/split_num)

    print("in_count=%d, each_count=%d" %(in_count, ecah_count))

    in_object.seek(0)

    out_file = in_file + "_split_" + "0"
    out_object = open(out_file, 'w')

#    while (loop <= split_num):
    while (True):
        line = in_object.readline()
        if (not line):
            print("Read EOF")
            break

        out_object.write(line)
        ref_line += 1
        if (ref_line > ecah_count * loop):
            out_object.close()
            loop += 1
            index = '%d' %loop
            out_file = in_file + "_split_" + index
            out_object = open(out_file, 'w')
            print("another file, filename:%s" %out_file)

    out_object.close()
    in_object.close()
    print("Split Finished!")


if __name__ == "__main__":
    Main()
