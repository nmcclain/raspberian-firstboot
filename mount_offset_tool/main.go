package main

import (
	"log"
	"os"
	"os/exec"
	"regexp"
	"strconv"
	"strings"
)

func main() {
	if err := doit(os.Args[1]); err != nil {
		log.Fatal(err)
	}
	log.Printf("OK!")
}

type DevInfo struct {
	Device  string
	Start   int
	Sectors int
}

func doit(img string) error {
	raw, err := exec.Command("/sbin/fdisk", "-l", "-o", "Device,Start,Sectors", img).Output()
	if err != nil {
		return err
	}
	sectorsRe := regexp.MustCompile(`Units: sectors of \d+ \* \d+ = (\d+) bytes`)
	out := strings.Split(strings.TrimSpace(string(raw)), "\n")
	unitSz := 0
	devices := []DevInfo{}
	for _, l := range out {
		if matches := sectorsRe.FindStringSubmatch(l); len(matches) == 2 {
			var err error
			unitSz, err = strconv.Atoi(matches[1])
			if err != nil {
				return err
			}
		} else if strings.HasPrefix(l, img) {
			parts := strings.Fields(l)
			d := DevInfo{Device: parts[0]}
			var err error
			d.Start, err = strconv.Atoi(parts[1])
			if err != nil {
				return err
			}
			d.Sectors, err = strconv.Atoi(parts[2])
			if err != nil {
				return err
			}
			devices = append(devices, d)
		}

	}
	log.Printf("unitSz = %+v\n", unitSz)
	log.Printf("devices = %+v\n", devices)
	// calculate and print mount cmd for img2
	for _, d := range devices {
		if strings.HasSuffix(d.Device, ".img2") {
			offset := unitSz * d.Start
			log.Printf("img2 mount cmd:\nmount -v -o offset=%d,loop %s /mnt\n", offset, img)
		}
	}

	return nil
}
