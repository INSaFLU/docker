#!/bin/bash
set -e


### any2fasta - necessary for abricate
echo "Install any2fasta"
git clone https://github.com/tseemann/any2fasta.git
cp any2fasta/any2fasta /usr/local/bin
