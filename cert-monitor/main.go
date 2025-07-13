package main

import (
	"fmt"
	"log"
	"os"
	"strings"

	"github.com/fsnotify/fsnotify"
)

func main() {
	// Multiple files via environment variable (separated by comma)
	filesEnv := os.Getenv("WATCH_FILES")
	if filesEnv == "" {
		fmt.Println("Please set the environment variable WATCH_FILES")
		fmt.Println("Example: WATCH_FILES=/path/to/file1.txt,/path/to/file2.txt go run main.go")
		os.Exit(1)
	}

	// Split files
	filenames := strings.Split(filesEnv, ",")

	// Remove whitespace
	for i, filename := range filenames {
		filenames[i] = strings.TrimSpace(filename)
	}

	// Create file watcher
	watcher, err := fsnotify.NewWatcher()
	if err != nil {
		log.Fatal(err)
	}
	defer watcher.Close()

	// Add all files to watch
	for _, filename := range filenames {
		err = watcher.Add(filename)
		if err != nil {
			log.Printf("Error adding '%s': %v", filename, err)
			os.Exit(1)
		} else {
			fmt.Printf("Watching file: %s\n", filename)
		}
	}
	fmt.Println("Press Ctrl+C to exit...")

	// Event handling in an infinite loop
	for {
		select {
		case event, ok := <-watcher.Events:
			if !ok {
				return
			}

			// Check if it's a write operation
			if event.Op&fsnotify.Write == fsnotify.Write {
				fmt.Printf("File '%s' was modified!\n", event.Name)
				executeCustomCode(event.Name)
			}

		case err, ok := <-watcher.Errors:
			if !ok {
				return
			}
			log.Println("Error:", err)
		}
	}
}

// This function is executed when files are changed
func executeCustomCode(filename string) {
	fmt.Printf(">>> Executing custom code for: %s\n", filename)

	// EXAMPLE: Read and display file content
	content, err := os.ReadFile(filename)
	if err != nil {
		fmt.Printf("Error reading file: %v\n", err)
		return
	}

	fmt.Printf("File content (%d bytes):\n%s\n", len(content), string(content))

	// Here you can insert your own code:
	// - API calls
	// - Database updates
	// - Start other programs
	// - Copy/move files
	// - etc.
}
