package main

import (
	"flag"
	"fmt"
	"time"
)

func main() {
	wasteCpu := flag.Int("waste-cpu", 0, "Waste CPU")
	hogMemory := flag.Int("hog-memory", 0, "Hog memory")

	flag.Parse()

	if *wasteCpu > 0 {
		wasteCPU(*wasteCpu)
	}
	if *hogMemory > 0 {
		memoryHogger(*hogMemory)
	}

}

func memoryHogger(limit int) {
	totalBytes := limit * 10 * 1024 * 1024
	chunkSize := 10 * 1024 * 1024 // 10 MB chunks

	allocatedMemory := make([]byte, totalBytes)

	for i := 0; i < totalBytes; i += chunkSize {
		// Ensure the memory is used by writing to each byte in the chunk
		for j := 0; j < chunkSize && i+j < totalBytes; j++ {
			allocatedMemory[i+j] = byte((i + j) % 256)
		}

		// Print the current memory usage
		fmt.Printf("Allocated %d MB\n", (i+chunkSize)/(1024*1024))

		// Sleep for a short time to slow down the allocation
		time.Sleep(1 * time.Second)
	}
}

func wasteCPU(threads int) {
	// Create a number of goroutines to waste CPU
	for i := 0; i < threads; i++ {
		go func() {
			// Loop forever
			fmt.Printf("Wasting CPU taks %d\n", i)
			for {
			}
		}()
	}
	select {}
}
