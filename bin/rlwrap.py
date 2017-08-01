#!/usr/bin/env python
# -*- coding: utf-8 -*-

# タイムアウトする版
# 2012-01-01 今のところこれが一番うまくいっているよう

import os
import sys
import tty
import pty
import select
import termios
import fcntl
import readline

def cleanup():
    termios.tcsetattr(sys.stdin.fileno(), termios.TCSANOW, old_attr)

def setupTerm():
    global old_attr
    old_attr = termios.tcgetattr(sys.stdin.fileno())

def main():
    setupTerm()

    if sys.argv[1] == "-p":
        PROMPT = sys.argv[2]
        cmd = sys.argv[3]
        args = sys.argv[3:]
    else:
        PROMPT = ""
        cmd = sys.argv[1]
        args = sys.argv[1:]
    try:
        (pid, ptyfd) = pty.fork()
    except:
        sys.stderr.write("fork failed\n")
        return

    if pid == 0:
        #print "child"
        tty.setraw(sys.stdin.fileno())
        try:
            os.execvp(cmd, args)
        except OSError:
            print "Cannot execute %s" % cmd
            sys.exit(1)
    else:
        try:
            setupTerm()

            try:
                fcntl.fcntl(ptyfd, fcntl.F_GETFL, os.O_NONBLOCK)
            except IOError:
                print "fcntrl failed"
                return

            # <?php
            #os.write(ptyfd, "<?php\r\n")
            # Interactive mode enabled が出るまで待つ
            while ptyfd in select.select([ptyfd], [], [], 0.5)[0]:
                from_pty = os.read(ptyfd, 512)
                os.write(sys.stdout.fileno(), from_pty)

            while True:
                try:
                    from_stdin = raw_input(PROMPT)
                except EOFError:
                    break
                #os.write(ptyfd, "echo " + from_stdin + ";\r\n")
                os.write(ptyfd, from_stdin + "\r\n")

                while True:
                    ready = select.select([ptyfd], [], [], 0.15)

                    if ptyfd in ready[0]:
                        from_pty = os.read(ptyfd, 512)
                        os.write(sys.stdout.fileno(), from_pty)
                    else:
                        break
        except OSError:
            pass
        except KeyboardInterrupt:
            pass
        cleanup()
            

main()
