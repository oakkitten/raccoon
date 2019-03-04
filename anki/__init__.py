from aqt import mw
from aqt.utils import tooltip, getText
from aqt.reviewer import Reviewer
from PyQt5.QtCore import Qt
from anki.hooks import wrap, addHook

from functools import partial

from PyQt5 import QtWidgets
cb = QtWidgets.QApplication.clipboard()

def copy(which):
    card = mw.reviewer.card
    try:
        kanjis = card.note().fields[0]
        if which == -1:
            cb.setText(kanjis)
        elif which in [0, 1]:
            cb.setText(kanjis[which])
    except:
        pass

def addShortcuts(shortcuts):
    shortcuts.insert(0, (Qt.Key_F2, partial(copy, 0)))
    shortcuts.insert(0, (Qt.Key_F3, partial(copy, 1)))
    shortcuts.insert(0, (Qt.Key_F4, partial(copy, -1)))

addHook("reviewStateShortcuts", addShortcuts)
