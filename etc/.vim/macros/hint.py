import os

class Hint:
    def __init__(self):
        self.home = os.getenv("HOME")
        self.loaded = {}
        self.unavailable = False
        self.dicts = {}

    def load(self, ft):
        try:
            self.f = open(self.home + "/.vim/ftplugin/" + ft + "/HINT")
            lines = self.f.readlines()
            self.dicts[ft] = {}
            for line in lines:
                a = line.split("\t")
                if len(a) < 2:
                    continue
                name, proto = a[0], a[1]
                self.dicts[ft][name] = proto.rstrip()
        except:
            self.unavailable = True
            return

    def get(self, ft, word):
        if self.unavailable:
            return
        if not ft in self.loaded:
            self.load(ft)
        if not ft in self.dicts:
            return
        if word in self.dicts[ft]:
            return self.dicts[ft][word].replace('"', '\\"')
        else:
            return None


if __name__ == '__main__':
    try:
        hint = Hint()
    except Exception, e:
        print e

