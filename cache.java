import java.util.*;
import java.util.Scanner;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedList;


//cache simulator will read an address 
//trace (a chronological list of memory addresses referenced), 
//simulate the cache, generate cache hit and miss data, and calculate the 
//execution time for the executing program. The address traces have been generated 
//by a simulator executing real programs. 

// start java cache class
public class cache {

	static int associativity = 1;          // Associativity of cache
	static int blocksize_bytes = 16;       // Cache Block size in bytes
	static int cachesize_kb = 16;          // Cache size in KB
	static int miss_penalty = 30;

	public static void print_usage()
	{
	  System.out.println("Usage: gunzip2 -c <tracefile> | java cache -a assoc -l blksz -s size -mp mispen\n");
	  System.out.println("  tracefile : The memory trace file\n");
	  System.out.println("  -a assoc : The associativity of the cache\n");
	  System.out.println("  -l blksz : The blocksize (in bytes) of the cache\n");
	  System.out.println("  -s size : The size (in KB) of the cache\n");
	  System.out.println("  -mp mispen: The miss penalty (in cycles) of a miss\n");
	  System.exit(0);
	}

	public static void main(String[] args) {
		  long address = 0;
		  int loadstore = 0;
		  int icount = 0;
		  	//initalize load_misses
			int load_misses = 0;
			//initialize load_hits
			int load_hits = 0;
			//initialize store_misses
			int store_misses = 0;
			//initialize store_hits
			int store_hits = 0;
			//initialize load_data
			int loaded_data = 0;
			//initialize stored_data
			int stored_data = 0;
			//initialize dirty_evictions
			int dirty_evictions = 0;
			//initialize executions_time
			int execution_time = 0;
			//initialize overall_miss_penalty
			int overall_miss_penalty = 0;
			//initialize memory_penalty
			int memory_penalty = 0;
			//initialize memor_cycles
			int memory_cycles = 0;
			//initializw instructions
			int instructions = 0;

			Map<Long, ArrayList<Long>> cache = new HashMap<>();
		  	int i = 0;
		  	int j = 0;

		 // Process the command line arguments
		  while (j < args.length) {
		    if (args[j].equals("-a")) {
		      j++;
		      if (j >= args.length)
		        print_usage();
		      associativity = Integer.parseInt(args[j]);
		      j++;
		    } else if (args[j].equals("-l")) {
		      j++;
		      if (j >= args.length)
		        print_usage ();
		      blocksize_bytes = Integer.parseInt(args[j]);
		      j++;
		    } else if (args[j].equals("-s")) {
		      j++;
		      if (j >= args.length)
		        print_usage ();
		      cachesize_kb = Integer.parseInt(args[j]);
		      j++;
		    } else if (args[j].equals("-mp")) {
		      j++;
		      if (j >= args.length)
		        print_usage ();
		      miss_penalty = Integer.parseInt(args[j]);
		      j++;
		    } else {
		    	System.out.println("Bad argument: " + args[j]);
		      print_usage ();
		    }
		  }

		  //find the tag bits of the instruction/trace
		  int tag_bits = 32 - (int)(Math.log((cachesize_kb * 1024 / associativity) / Math.log(2)));
		  System.out.println("\tCache parameters:\n");
		  System.out.format("\tCache Size (KB)\t\t\t%d\n", cachesize_kb);
		  System.out.format("\tCache Associativity\t\t%d\n", associativity);
		  System.out.format("\tCache Block Size (bytes)\t%d\n", blocksize_bytes);
		  System.out.format("\tMiss penalty (cyc)\t\t%d\n",miss_penalty);
		  System.out.println("\n");

		  //scanner to read the input traces
		  Scanner sc = new Scanner(System.in);
		  while (sc.hasNextLine()) {
		      if (sc.hasNext()){
			sc.next(); //get rid of hashmark
			loadstore = sc.nextInt();
			address = sc.nextLong(16); //16 specifies it's in hex
			icount = sc.nextInt();
			i++;
			execution_time+=icount;
			instructions += icount;
			//find the cachesize
			int cachesize = cachesize_kb * 1024;
			//find the tag of the instructions
			long tag = address >>> (32 - tag_bits);
			//find the index of the instructions
			long index = (address / blocksize_bytes) % (cachesize / (blocksize_bytes * associativity));
			//now we have to find out if something if a hit or a miss
			boolean hit = cache.containsKey(index) && cache.get(index).indexOf(tag)!=-1;
			//if it is not a hit, then we identify this as a miss
			boolean miss = !hit;

			//do the calculations for our results if something is a miss
			if(hit){
				//find where the hit is
				int placement_of_hit = cache.get(index).indexOf(tag);
				//find where the current load store is
				Long current_load_store = cache.get(index).remove(placement_of_hit+1);
				//find the current tag of the hit
				Long current_tag = cache.get(index).remove(placement_of_hit);
				//if the load store hit is 1, then put it to the load store long
				if(loadstore == 1){
					cache.get(index).add(0, (long)loadstore);
				}
				//else then put it to the current load store
				else{
					cache.get(index).add(0, current_load_store);
				}
				cache.get(index).add(0, current_tag);
				//if the load store hit is 0, add another hit and also the the loaded data
				if(loadstore == 0){
					//add one to the load hits
					load_hits++;
					//add one to the loaded data
					loaded_data++;
				}
				//if the load store is 1 then at means it is a store, then we must count up the store hits and stored data
				if(loadstore == 1){
					//add one to the store hits
					store_hits++;
					//add one to the stored data
					stored_data++;
				}
			}
			//handle the data if it is a miss
			//a miss will slow down the performance meaning we will take longer cycles to
			//execute out program
			if(miss){
				//slow down the executions time by adding the miss penalty
				execution_time+=miss_penalty;
				//slow down the memory cycles by adding the miss penalty
				memory_cycles+=miss_penalty;
				//slow down our memory penalty by adding the miss penalty to it
				memory_penalty+=miss_penalty;

				//if the cache has the wanted index, we execute some calculations
				if(cache.containsKey(index)){

					if(cache.get(index).size() == associativity*2){
						//find the last tag
						int last_hit_tag = associativity * 2 - 2;
						///update the current load store
						long current_load_store = cache.get(index).remove(last_hit_tag+1);
						//remove the last tag
						cache.get(index).remove(last_hit_tag);
						cache.get(index).add(0, tag);
						cache.get(index).add(1, (long)loadstore);
						//if the current load store is equal to 1 add to execution time, 
						//memory cycle, memory penalty, and dirty evictions
						if(current_load_store == 1){
							//add two tp the execution time
							execution_time+=2;
							//add 2 to the memory cycles
							memory_cycles+=2;
							//add 2 to the memory penalty
							memory_penalty+=2;
							//add 1 to the dirty evictions
							dirty_evictions++;
						}
					}
					else{
						//find the size
						int size = cache.get(index).size();
						cache.get(index).add(0, tag);
						cache.get(index).add(1, (long)loadstore);
					}
				}
				else{
					//create a new array
					ArrayList<Long> calcutions = new ArrayList<Long>();
					//add the tag to this arraylist
					calcutions.add(tag);
					//add the load store
					calcutions.add((long)loadstore);
					cache.put(index,calcutions);
				}
				overall_miss_penalty+=1;
				//if the load store is 0 , then that means that is it a load miss and add one to the load misses and loaded data
				if(loadstore == 0){
					//add one to the load misses
					load_misses++;
					//add one the loaded data
					loaded_data++;
				}
				//if the load store is 1, that means it is a store miss and add one to the store misses and stored data
				if(loadstore == 1){
					//add 1 to the store misses
					store_misses++;
					//add 1 to the stored data
					stored_data++;
				}
			}
		      } else {
			  break;
		      }
		  }
		  //produce miss rates for all accesses, miss rates for loads only, and execution 
		  //time for the program, in cycles. It should also show total CPI, and average memory 
		  //access time (cycles per access, assuming 0 cycles for a hit and miss penalty for a miss). 
		  //For execution time, assume the following: All instructions (except loads) take one cycle. A 
		  //load takes one cycle plus the miss penalty. The miss penalty is 0 cycles for a cache hit and 30 
		  //cycles for a cache miss (unless specified otherwise). Loads or stores each result in a stall 
		  //for miss-penalty cycles.
		   //  Use your simulator to output the following statistics.  The 
		  //  print statements are provided, just replace the question marks with
		  //  your calcuations.

		  System.out.println("\tSimulation results:\n");
		  //print the execution time
		  System.out.format("\texecution time %d cycles\n", execution_time);
		  //print the number of instructions
		  System.out.format("\tinstructions %d\n", instructions);
		  //print the num of memory accesses
		  System.out.format("\tmemory accesses %d\n", i);
		  //print the overall miss rate
		  System.out.format("\toverall miss rate %.2f\n", (float)((load_misses + store_misses))/i);
		  //pring the miss rate for the reads
		  System.out.format("\tread miss rate %.2f\n", (float)(load_misses)/loaded_data);
		  //print the CPI for the memory
		  System.out.format("\tmemory CPI %.2f\n", (float)memory_cycles/instructions);
		  //print the total overal CPI of the program
		  System.out.format("\ttotal CPI %.2f\n", (float)execution_time/instructions);
		  //print the memory access time
		  System.out.format("\taverage memory access time %.2f cycles\n",  (float)memory_penalty/i);
		  //pring the number of dirty evictions for the given file
		  System.out.format("\tdirty evictions %d\n", dirty_evictions);
		  //print the number of misses for the load instructions
		  System.out.format("\tload_misses %d\n", load_misses);
		  //print the number of misses for the store instructions
		  System.out.format("\tstore_misses %d\n", store_misses);
		  //print the number of hits for the given file
		  System.out.format("\tload_hits %d\n", load_hits);
		  //print the number of hits for the store instructions
		  System.out.format("\tstore_hits %d\n", store_hits);
	}

}
