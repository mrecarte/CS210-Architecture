//Marilyn Recarte

public class BitOps{
	
	//1
	
    public static int isOdd(int x){
        return x & 1;
    }

    
   //2
    
   public static int DivBy4(int x){
	   return x >> 2;
	   }

    //3
   
   public static int nearestOdd(int x){
	   return x|1;
	   }

   //4
  
    public static int flipParity(int x){
        return x ^ 1;
    }

   //5
   
    public static int isNegative(int x){
        return ( x & 0x80000000)>>> 31;
    }
    
    //6
    
    public static int clearBits(int x){
        int bitz = 0b11110000;
        return x & bitz;
    }

    //7
    
    public static int setBits(int x){
        int tot = 0b11111111111111111111111100001111;
        int temp = 0b01100000;
        
        return (x & tot)| temp ;
        

    }}
