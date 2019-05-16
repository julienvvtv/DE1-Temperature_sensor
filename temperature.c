//-----------------------------------------------------
//------------- Programme Temperature ---------------
//-----------------------------------------------------

#include <16F876.h>

#fuses HS,NOWDT,NOPROTECT,NOLVP
#use delay(clock=20000000)
#use i2c(master, sda=PIN_C4, scl=PIN_C3)

//-------------------------E/S------------------------
#include "Define.h"
#include "db_lcd.c"

Byte CONST temp = 0b10010000;  // Adresse  Température [TMP100] (0x90)
//-------------------------Var------------------------


//-------------------------xxx------------------------


//-------------Lecture  I2C  1 byte------------------
signed byte lec_i2c(byte device, byte address) {
   signed BYTE data;

   i2c_start();
   i2c_write(device);
   i2c_write(address);
   i2c_start();
   i2c_write(device | 1);  //| est un ou bit à bit et faire |1 revient à recopier device
   data=i2c_read(0);
   i2c_stop();
   return(data);
}

//-------------Lecture  I2C  2 bytes -----------------
signed int16 lecdb_i2c(byte device, byte address) {
   BYTE dataM,dataL;
   int16 data;

   i2c_start();
   i2c_write(device);
   i2c_write(address);
   i2c_start();
   i2c_write(device | 1);
   dataM = i2c_read(1);				// Lecteur du MSB (8 bits les plus significatifs), on veut lire 16 bits mais on ne peut transférer que 8 bits à la fois
   dataL = i2c_read(0);				// Lecteur du LSB (8 bits les moins significatifs)
   i2c_stop();
   data=((dataM*256)+dataL);		// recuperation de la valeur finale (les 8 bits les plus significatifs on les multiplie par 256 ce qui revient à les décaler de 8 bits et on y rajoute les 8 bits les moins significatifs)
   lcd_gotoxy(1,1);
   printf(lcd_char,"MSB:%d  LSB:%d  ",dataM,dataL);	
   return(data);
}

//-------------Ecriture  I2C------------------
void ecr_i2c(byte device, byte address, byte data) {
   i2c_start();
   i2c_write(device);
   i2c_write(address);
   i2c_write(data);
   i2c_stop();
}

//-------------Lecture Temperature I2C------------------
void lecture_temp() {
		float celcius;
		float val;

		ecr_i2c(temp,0x01,0x20); // on envoie au capteur temp (à l'adresse 0000 0001 qui correspond au registre de configuration) la donnée 0010 0000, cette donnée correspond au tableau 6 (datasheet), ici ça active R0 -> ça pose la résolution à 10bits, c'est-à-dire 0.25°C
		celcius=lecdb_i2c(temp,0b00000000); // l'adresse 0 correspond à une lecture de température
		val=(celcius/256);
		delay_ms(85);
		lcd_gotoxy(1,2);
		printf(lcd_char,"Temp.:%f C ",val);
}

//-------------------------xxx------------------------
void affiche2() {
		lecture_temp();
		delay_ms(200);
}

//-------------------------xxx------------------------
void main() {

	   	lcd_init();
	   	lcd_char("\fProjet Temperature\n");
		lcd_char("(C)FPMS - 2006");
		delay_ms(1000);	
		lcd_char("\fLecture I2c...");
		delay_ms(800);	
		lcd_cursor(0);
test:
		affiche2();
		goto test;
}