# DE1-temperature_sensor

The goal of this project was to learn to control an I2C temperature sensor with an Altera Cyclone V SoC using Quartus II starting from a simple code C that did the same job on a PIC card  (temperature.c). 

The Présentation_I2C.ppt is a powerpoint presenting the project and the Tutorial.pdf is a tutorial to reproduce the project we made.

In the P2 zip file :

You will find .vhd files and a test bench(es) corresponding to their tasks.

The i2c_master.vhd file is the program that manages the communication in I2C with the device. It is very inspired of a i2c_master.vhd file find on the internet (https://www.digikey.com/eewiki/pages/viewpage.action?pageId=10125324). 

The app.vhd is the program that includes the state machine of the sensor.

The appdriver.vhd is the grouping of the driver and the application where you only need to name the pins you want to use to flash it on the SoC. Our mapping was made in the appdriverDE1SoC.vhd

Demonstration : https://www.youtube.com/watch?v=I1YpRnDo-Lw
