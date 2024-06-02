/*
Configuration for the code below:

Connect portA to Motor
Jumpers of portA are : 5V, pull up ( top one to left, other to left )

Connect portE to Buttons
Jumpers of portE are : 3.3V, pull up ( top one to left, other to left )

*/

// These variables are used for button debouncing.
// lastB0 stands for the previous value of button 0.
// lastB1 stands for the previous value of button 1.
unsigned char lastB0 = 1;
unsigned char lastB1 = 1;

void main() {

	AD1PCFG = 0xFFFF; 	// configure the analog input pins as digital I/O.
	DDPCON.JTAGEN = 0; 	// disable JTAG

	TRISA = 0x0000;  	// portA is output to drive motor.
	TRISE = 0XFFFF;  	// portE is inputs to read push-buttons.

	// initial values for port A and E
	LATA = 0Xffff;		
	LATE = 0X0000;

	// initial delay
	Delay_ms(100);

	while(1)
	{
		// if the value of the buttons is the same as before
		if ( lastB0 == portEbits.RE0 && lastB1 == portEbits.RE1 ) {
			// update debouncer variables
			lastB0 = portEbits.RE0;
			lastB1 = portEbits.RE1;
			continue;
		}
		// if button 0 is pushed and button 1 is not pushed
		if ( portEbits.RE0 == 0 && portEbits.RE1 == 1 ) {
			Delay_ms(1000);		// after 1 second
			portAbits.RA1 = 1;	
			portAbits.RA2 = 0;	// drive motor clockwise
		}
		// if button 1 is pushed and button 0 is not pushed
		else if ( portEbits.RE0 == 1 && portEbits.RE1 == 0 ) {
			Delay_ms(1000);		// after 1 second
			portAbits.RA1 = 0;	// drive motor counter-clockwise
			portAbits.RA2 = 1;
		}
		// if both button 0 and 1 is pushed
		else if ( portEbits.RE0 == 0 && portEbits.RE1 == 0 ) {
			Delay_ms(1000);		// after 1 second
			portAbits.RA1 = 1;	// stop motor
			portAbits.RA2 = 1;
		}
		// update debouncer variables
		lastB0 = portEbits.RE0;
		lastB1 = portEbits.RE1;
	}//while
}//main
