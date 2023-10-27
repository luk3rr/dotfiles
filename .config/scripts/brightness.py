#!/usr/bin/env python3

import sys
from PyQt5.QtCore import Qt, QTimer, QEvent
from PyQt5.QtWidgets import QApplication, QSlider, QVBoxLayout, QWidget, QLabel, QDesktopWidget
from PyQt5.QtGui import QIcon
import subprocess

class BrightnessSlider(QWidget):
    def __init__(self, parent=None):
        super().__init__(parent)
        layout = QVBoxLayout(self)
        self.slider = QSlider(Qt.Vertical)
        self.slider.setMinimum(0)
        self.slider.setMaximum(100)
        self.slider.valueChanged.connect(self.set_brightness)
        layout.addWidget(self.slider)

        self.label = QLabel("0%")  # Inicialmente exibe "0%"
        self.label.setAlignment(Qt.AlignCenter)
        layout.addWidget(self.label)

        self.timer = QTimer()
        self.timer.timeout.connect(self.apply_brightness)

        # Obter o brilho atual e configurar a barra de rolagem
        self.current_brightness = self.get_current_brightness()
        self.slider.setValue(self.current_brightness)
        self.label.setText(f"{self.current_brightness}%")

    def get_current_brightness(self):
        command = 'ddcutil getvcp 0x10 | grep "current value"'
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        output = result.stdout.strip()
        current_brightness = int(output.split()[-1])
        return current_brightness

    def set_brightness(self, value):
        self.brightness = value
        self.timer.start(200)  # Inicia o temporizador com um atraso de 200ms
        self.label.setText(f"{value}%")  # Atualiza a porcentagem exibida no QLabel

    def apply_brightness(self):
        self.timer.stop()
        command = f'ddcutil setvcp 0x10 {self.brightness}'
        subprocess.run(command, shell=True)

    def event(self, event):
        if event.type() == QEvent.WindowDeactivate:
            self.close()
        return super().event(event)

def main():
    app = QApplication(sys.argv)
    app.setWindowIcon(QIcon('brightness_icon.png'))  # Defina o ícone da janela

    window = BrightnessSlider()
    window.setWindowFlags(Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint)
    window.setAttribute(Qt.WA_TranslucentBackground)
    window.setAttribute(Qt.WA_NoSystemBackground, False)
    window.setWindowOpacity(0.9)
    window.resize(20, 200)  # Ajuste o tamanho da janela conforme necessário

     # Posicionar a janela no canto direito da tela
    desktop = QDesktopWidget().screenGeometry()
    offset = 65
    window.move(desktop.right() - window.width() - offset, desktop.top() + (desktop.height() - window.height()) // 2)


    window.show()
    sys.exit(app.exec_())

if __name__ == '__main__':
    main()
