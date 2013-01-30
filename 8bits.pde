/*-----------------------------------------------------
Author: Alexis Sánchez <aasanchez@gmail.com>
First release: 30/01/2013
Description: Control de PinguinoBoards 8bits via USB-CDC
-----------------------------------------------------*/

#include <string.h>
#include <stdlib.h>
#define TotalPines 17 //Este valor debe cambiar según el microcontrolador base

char lectura[21], *bloque;
int par1, valor, cont, i;

void setup() {
}

void leer_cadena() {
    unsigned char valor_leido[21];
    unsigned char receivedbyte;
    int cont = 1;
    while (cont){
        receivedbyte = CDC.read(valor_leido);
        valor_leido[receivedbyte] = 0;
        if (receivedbyte > 0) cont = 0;
    }
    strcpy(lectura,valor_leido);
}

void loop() {
    leer_cadena();
    cont = 0;

    if (strncmp(lectura, "pinMode", 7) == 0){
        for (bloque = strtok(lectura,"("); bloque != NULL; bloque = strtok(NULL, ",") ){
            switch (cont){
                case 0:
                    break;
                case 1:
                    par1 = atoi(bloque);
                    break;
                case 2:
                    if (strncmp(bloque, "INPUT", 5) == 0) pinMode(par1,INPUT);
                    else if (strncmp(bloque, "OUTPUT", 6) == 0) pinMode(par1,OUTPUT);
                    break;
            }
            cont+=1;
        }
    }

    else if (strncmp(lectura, "digitalWrite", 12) == 0){
        for (bloque = strtok(lectura,"("); bloque != NULL; bloque = strtok(NULL, ",") ){
            switch (cont){
                case 0:
                    break;
                case 1:
                    par1 = atoi(bloque);
                    break;
                case 2:
                    if (strncmp(bloque, "HIGH", 4) == 0) digitalWrite(par1,HIGH);
                    else if (strncmp(bloque, "LOW", 3) == 0) digitalWrite(par1,LOW);
                    break;
            }
            cont+=1;
        }
    }

    else if (strncmp(lectura, "analogWrite", 11) == 0){
        for (bloque = strtok(lectura,"("); bloque != NULL; bloque = strtok(NULL, ",") ){
            switch (cont){
                case 0:
                    break;
                case 1:
                    par1 = atoi(bloque);
                    break;
                case 2:
                    analogWrite(par1,atoi(bloque));
                    break;
            }
            cont+=1;
        }
    }

    else if (strncmp(lectura, "digitalRead", 11) == 0){
        for (bloque = strtok(lectura,"("); bloque != NULL; bloque = strtok(NULL, ")") ){
            switch (cont){
                case 0:
                    break;
                case 1:
                    CDC.printf("%d\n",digitalRead(atoi(bloque)));
                    break;
            }
            cont+=1;
        }
    }

    else if (strncmp(lectura, "analogRead", 10) == 0){
        for (bloque = strtok(lectura,"("); bloque != NULL; bloque = strtok(NULL, ")") ){
            switch (cont){
                case 0:
                    break;
                case 1:
                    CDC.printf("%d\n",analogRead(atoi(bloque)));
                    break;
            }
            cont+=1;
        }
    }

    else if (strncmp(lectura, "eepromRead", 10) == 0){
        for (bloque = strtok(lectura,"("); bloque != NULL; bloque = strtok(NULL, ")") ){
            switch (cont){
                case 0:
                    break;
                case 1:
                    CDC.printf("%d\n",EEPROM.read(atoi(bloque)));
                    break;
            }
            cont+=1;
        }
    }

    else if (strncmp(lectura, "eepromWrite", 11) == 0){
        for (bloque = strtok(lectura,"("); bloque != NULL; bloque = strtok(NULL, ",") ){
            switch (cont){
            case 0:
                break;
            case 1:
                par1 = atoi(bloque);
                break;
            case 2:
                bloque = strtok(bloque,")");
                EEPROM.write(par1, atoi(bloque));
                break;
            }
            cont+=1;
        }
    }

    else if (strncmp(lectura, "delay", 5) == 0){
        for (bloque = strtok(lectura,"("); bloque != NULL; bloque = strtok(NULL, ")") ){
            switch (cont){
                case 0:
                    break;
                case 1:
                    delay(atoi(bloque));
                    break;
            }
            cont+=1;
        }
    }

    else if (strncmp(lectura, "delayMicroseconds", 17) == 0){
        for (bloque = strtok(lectura,"("); bloque != NULL; bloque = strtok(NULL, ")") ){
            switch (cont){
                case 0:
                    break;
                case 1:
                    delayMicroseconds(atoi(bloque));
                    CDC.printf("Done\n");
                    break;
            }
            cont+=1;
        }
    }

    else if (strcmp(lectura, "reset") == 0)
        reset();
    }