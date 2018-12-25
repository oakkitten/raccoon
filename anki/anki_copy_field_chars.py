from aqt import mw
from aqt.utils import tooltip, getText
from aqt.reviewer import Reviewer
from PyQt4.QtCore import Qt

# clip
from PyQt4 import QtGui
cb = QtGui.QApplication.clipboard()

# replace _keyHandler in reviewer.py to add a keybinding

def newKeyHandler(self, evt):
    key = unicode(evt.text())
    card = mw.reviewer.card
    if evt.key() in [Qt.Key_F2, Qt.Key_F3, Qt.Key_F4]:
        try:
            kanji = card.note().fields[0]
            if evt.key() != Qt.Key_F4:
                kanji = kanji[0 if evt.key() == Qt.Key_F2 else 1]
            cb.setText(kanji)
        except:
            pass
        #tooltip(card.note().fields[0][0])
    else:
        origKeyHandler(self, evt)

origKeyHandler = Reviewer._keyHandler
Reviewer._keyHandler = newKeyHandler

