package main

import (
  "fmt"
  "log"
  "net"
  "net/http"
  "os"
)

func helloHandler(w http.ResponseWriter, r *http.Request) {
  hostname, _ := os.Hostname()
  ip := getLocalIP()
  fmt.Fprintf(w, "Hello, Nomad from Go!\nHostname: %s\nIP: %s\n", hostname, ip)
}

// getLocalIP returns the first non-loopback IP address found
func getLocalIP() string {
  addrs, err := net.InterfaceAddrs()
  if err != nil {
    return "unknown"
  }
  for _, addr := range addrs {
    if ipnet, ok := addr.(*net.IPNet); ok && !ipnet.IP.IsLoopback() && ipnet.IP.To4() != nil {
      return ipnet.IP.String()
    }
  }
  return "unknown"
}

func main() {
  http.HandleFunc("/", helloHandler)
  log.Println("Starting server on :8000")
  log.Fatal(http.ListenAndServe(":8000", nil))
}
