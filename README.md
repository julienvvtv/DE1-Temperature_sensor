# DE1-temperature_sensor

The goal of this project was to learn to control an I2C temperature sensor with an Altera Cyclone V SoC using Quartus II starting from a simple code C that did the same job on a PIC card  (temperature.c). 

In this project :

In each folder, you will find a .vhd file and a test bench corresponding to its task.

In the I2C_driver folder, you will find the program that manages the communication in I2C with the device. It is very inspired of a i2c_master.vhd file find on the internet (https://www.digikey.com/eewiki/pages/viewpage.action?pageId=10125324). 

In the App folder, you will find the program that includes the state machine of the sensor.

In the Appdriver folder, you will find the grouping of the driver and the application where you only need to name the pins you want to use to flash it on the SoC.

Demonstration at https://www.youtube.com/watch?v=I1YpRnDo-Lw
