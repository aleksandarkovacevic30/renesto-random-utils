#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define NUM_OF_CONV_TABLE 8

/*
compile it with: 
gcc -o convert convert.c
run it with:
convert input.txt output.txt && hexdump -ve '1/1 "%.2X"' output.txt

*/

int main ( int argc, char *argv[] )
{

 static unsigned char utfconv[NUM_OF_CONV_TABLE] = 
     {0x84, 0x96, 0x9C, 0xA4, 0xB6, 0xBC, 0x9F}; 
 static unsigned char conv[NUM_OF_CONV_TABLE] = 
     {0xC4, 0xD6, 0xDC, 0xE4, 0xF6, 0xFC, 0xDF}; 
     //Ä, Ö, Ü, ä, ö , ü, ß
 static unsigned char values[NUM_OF_CONV_TABLE] = 
     { 0x5B, 0x5C, 0x5D, 0x7B, 0x7C, 0x7D, 0x7E }; 


    if ( argc != 3 ) /* argc should be 2 for correct execution */
    {
        /* We print argv[0] assuming it is the program name */
        printf( "Text Encoding Convertor: From UTF-8/ISO-8859-2, to ISO-646-DE (ASCII-DE)");
        printf( "usage: <inputFilePath>, <outputFilePath>");
    }
    else 
    {
        // We assume argv[1] is a filename to open
        FILE *fileIn = fopen( argv[1], "r" );
        FILE *fileOut = fopen( argv[2], "w");

        /* fopen returns 0, the NULL pointer, on failure */
        if ( fileIn == 0 || fileOut == 0)
        {
            printf( "Could not open file\n" );
        }
        else 
        {
            unsigned char x;
/*            unsigned char size;
            if (strcmp(covertToUpper(argv[3]),"UTF-8") != 0) {
                size=2;
            } else {
                size=1;
            }*/
            /* read one character at a time from file, stopping at EOF, which
               indicates the end of the file.  Note that the idiom of "assign
               to a variable, check the value" used below works because
               the assignment statement evaluates to the value assigned. */
            unsigned char isUTF=0;
            unsigned char wasC3=0;
            while  ( fread(&x,1,1,fileIn)==1 )
            {
                int i=0;
                int o=x;
             while (i<NUM_OF_CONV_TABLE) {
                 if (x==0xC3) {
                     isUTF=1;
                     wasC3=1;
                     break;
                 }
              if (!isUTF && conv[i]==x) {
                  o=values[i];
                  break;
              }
              if (isUTF && utfconv[i]==x) {
                  o=values[i];
                        wasC3=0;
                  break;
              } else {
                  wasC3=0;
              }   
              
              i++;
             }
                if (!wasC3) {
                    printf("%c(%02x)\n",o,o);
                 fwrite( &o, 1, 1, fileOut );
                }
            }

   fclose( fileIn );
   fclose( fileOut );

   /* If nrd == 0 --> Reached EOF
      If nrd <  0 --> Some kind of error */
        }
    }
}
