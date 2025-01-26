.PHONY: run-frequency run-coverage run-mutation plot-frequencies plot-rare-words plot-missing-words run-entropy-human run-entropy-ecoli run-entropy-mouse run-entropy-viruses run-entropy run-merge

run-frequency:
	@echo "Running frequency analysis for homosapiens..."
	@mix wordcount data/uniprot-sequences/homosapiens.csv , 1 2 data/output/homosapiens/frequency/k2.csv frequency
	@mix wordcount data/uniprot-sequences/homosapiens.csv , 1 3 data/output/homosapiens/frequency/k3.csv frequency
	@mix wordcount data/uniprot-sequences/homosapiens.csv , 1 4 data/output/homosapiens/frequency/k4.csv frequency
	@mix wordcount data/uniprot-sequences/homosapiens.csv , 1 5 data/output/homosapiens/frequency/k5.csv frequency
	@mix wordcount data/uniprot-sequences/homosapiens.csv , 1 6 data/output/homosapiens/frequency/k6.csv frequency

	@echo "Running frequency analysis for ecoli..."
	@mix wordcount data/uniprot-sequences/ecoli.csv , 1 2 data/output/ecoli/frequency/k2.csv frequency
	@mix wordcount data/uniprot-sequences/ecoli.csv , 1 3 data/output/ecoli/frequency/k3.csv frequency
	@mix wordcount data/uniprot-sequences/ecoli.csv , 1 4 data/output/ecoli/frequency/k4.csv frequency
	@mix wordcount data/uniprot-sequences/ecoli.csv , 1 5 data/output/ecoli/frequency/k5.csv frequency
	@mix wordcount data/uniprot-sequences/ecoli.csv , 1 6 data/output/ecoli/frequency/k6.csv frequency

	@echo "Running frequency analysis for mouse..."
	@mix wordcount data/uniprot-sequences/mouse.csv , 1 2 data/output/mouse/frequency/k2.csv frequency
	@mix wordcount data/uniprot-sequences/mouse.csv , 1 3 data/output/mouse/frequency/k3.csv frequency
	@mix wordcount data/uniprot-sequences/mouse.csv , 1 4 data/output/mouse/frequency/k4.csv frequency
	@mix wordcount data/uniprot-sequences/mouse.csv , 1 5 data/output/mouse/frequency/k5.csv frequency
	@mix wordcount data/uniprot-sequences/mouse.csv , 1 6 data/output/mouse/frequency/k6.csv frequency

	@echo "Running frequency analysis for viruses..."
	@mix wordcount data/uniprot-sequences/viruses.csv , 1 2 data/output/viruses/frequency/k2.csv frequency
	@mix wordcount data/uniprot-sequences/viruses.csv , 1 3 data/output/viruses/frequency/k3.csv frequency
	@mix wordcount data/uniprot-sequences/viruses.csv , 1 4 data/output/viruses/frequency/k4.csv frequency
	@mix wordcount data/uniprot-sequences/viruses.csv , 1 5 data/output/viruses/frequency/k5.csv frequency
	@mix wordcount data/uniprot-sequences/viruses.csv , 1 6 data/output/viruses/frequency/k6.csv frequency


run-coverage:
	@echo "Running coverage analysis for homosapiens..."
	@mix wordcount data/uniprot-sequences/homosapiens.csv , 1 2 data/output/homosapiens/coverage/k2.csv coverage
	@mix wordcount data/uniprot-sequences/homosapiens.csv , 1 3 data/output/homosapiens/coverage/k3.csv coverage
	@mix wordcount data/uniprot-sequences/homosapiens.csv , 1 4 data/output/homosapiens/coverage/k4.csv coverage
	@mix wordcount data/uniprot-sequences/homosapiens.csv , 1 5 data/output/homosapiens/coverage/k5.csv coverage
	@mix wordcount data/uniprot-sequences/homosapiens.csv , 1 6 data/output/homosapiens/coverage/k6.csv coverage

	@echo "Running coverage analysis for ecoli..."
	@mix wordcount data/uniprot-sequences/ecoli.csv , 1 2 data/output/ecoli/coverage/k2.csv coverage
	@mix wordcount data/uniprot-sequences/ecoli.csv , 1 3 data/output/ecoli/coverage/k3.csv coverage
	@mix wordcount data/uniprot-sequences/ecoli.csv , 1 4 data/output/ecoli/coverage/k4.csv coverage
	@mix wordcount data/uniprot-sequences/ecoli.csv , 1 5 data/output/ecoli/coverage/k5.csv coverage
	@mix wordcount data/uniprot-sequences/ecoli.csv , 1 6 data/output/ecoli/coverage/k6.csv coverage

	@echo "Running coverage analysis for mouse..."
	@mix wordcount data/uniprot-sequences/mouse.csv , 1 2 data/output/mouse/coverage/k2.csv coverage
	@mix wordcount data/uniprot-sequences/mouse.csv , 1 3 data/output/mouse/coverage/k3.csv coverage
	@mix wordcount data/uniprot-sequences/mouse.csv , 1 4 data/output/mouse/coverage/k4.csv coverage
	@mix wordcount data/uniprot-sequences/mouse.csv , 1 5 data/output/mouse/coverage/k5.csv coverage
	@mix wordcount data/uniprot-sequences/mouse.csv , 1 6 data/output/mouse/coverage/k6.csv coverage

	@echo "Running coverage analysis for viruses..."
	@mix wordcount data/uniprot-sequences/viruses.csv , 1 2 data/output/viruses/coverage/k2.csv coverage
	@mix wordcount data/uniprot-sequences/viruses.csv , 1 3 data/output/viruses/coverage/k3.csv coverage
	@mix wordcount data/uniprot-sequences/viruses.csv , 1 4 data/output/viruses/coverage/k4.csv coverage
	@mix wordcount data/uniprot-sequences/viruses.csv , 1 5 data/output/viruses/coverage/k5.csv coverage
	@mix wordcount data/uniprot-sequences/viruses.csv , 1 6 data/output/viruses/coverage/k6.csv coverage

run-mutation:
	@echo "Running mutation analysis for homosapiens..."
	@mix mutation data/human_mutagen.csv 2 data/output/homosapiens/mutation/k2.csv
	@mix mutation data/human_mutagen.csv 3 data/output/homosapiens/mutation/k3.csv
	@mix mutation data/human_mutagen.csv 4 data/output/homosapiens/mutation/k4.csv

plot-frequencies:
	@echo "Plotting frequency analysis for all species..."
	@python python/plot_frequencies.py --kmer 2 --modality coverage
	@python python/plot_frequencies.py --kmer 3 --modality coverage
	@python python/plot_frequencies.py --kmer 4 --modality coverage
	@python python/plot_frequencies.py --kmer 5 --modality coverage
	@python python/plot_frequencies.py --kmer 6 --modality coverage

	@python python/plot_frequencies.py --kmer 2 --modality frequency
	@python python/plot_frequencies.py --kmer 3 --modality frequency
	@python python/plot_frequencies.py --kmer 4 --modality frequency
	@python python/plot_frequencies.py --kmer 5 --modality frequency
	@python python/plot_frequencies.py --kmer 6 --modality frequency

plot-rare-words:
	@echo "Plotting rare words analysis for all species..."
	@python python/rare_words_distribution.py --kmer 2
	@python python/rare_words_distribution.py --kmer 3
	@python python/rare_words_distribution.py --kmer 4
	@python python/rare_words_distribution.py --kmer 5
	@python python/rare_words_distribution.py --kmer 6

plot-missing-words:
	@echo "Plotting missing words analysis for all species..."
	@python python/missing_words_distribution.py --kmer 2
	@python python/missing_words_distribution.py --kmer 3
	@python python/missing_words_distribution.py --kmer 4
	@python python/missing_words_distribution.py --kmer 5
	@python python/missing_words_distribution.py --kmer 6

run-entropy-human:
	@echo "Running entropy analysis for homosapiens..."
	@mix entropy data/output/homosapiens/frequency/k2.csv 2 word
	@mix entropy data/output/homosapiens/frequency/k3.csv 3 word
	@mix entropy data/output/homosapiens/frequency/k4.csv 4 word
	@mix entropy data/output/homosapiens/frequency/k5.csv 5 word
	@mix entropy data/output/homosapiens/frequency/k6.csv 6 word

run-entropy-ecoli:
	@echo "Running entropy analysis for ecoli..."
	@mix entropy data/output/ecoli/frequency/k2.csv 2 word
	@mix entropy data/output/ecoli/frequency/k3.csv 3 word
	@mix entropy data/output/ecoli/frequency/k4.csv 4 word
	@mix entropy data/output/ecoli/frequency/k5.csv 5 word
	@mix entropy data/output/ecoli/frequency/k6.csv 6 word

run-entropy-mouse:
	@echo "Running entropy analysis for mouse..."
	@mix entropy data/output/mouse/frequency/k2.csv 2 word
	@mix entropy data/output/mouse/frequency/k3.csv 3 word
	@mix entropy data/output/mouse/frequency/k4.csv 4 word
	@mix entropy data/output/mouse/frequency/k5.csv 5 word
	@mix entropy data/output/mouse/frequency/k6.csv 6 word

run-entropy-viruses:
	@echo "Running entropy analysis for viruses..."
	@mix entropy data/output/viruses/frequency/k2.csv 2 word
	@mix entropy data/output/viruses/frequency/k3.csv 3 word
	@mix entropy data/output/viruses/frequency/k4.csv 4 word
	@mix entropy data/output/viruses/frequency/k5.csv 5 word
	@mix entropy data/output/viruses/frequency/k6.csv 6 word

run-entropy:
	@make run-entropy-human
	@make run-entropy-ecoli
	@make run-entropy-mouse
	@make run-entropy-viruses

run-merge:
	@echo "Merge data into one file..."
	@mix merge homosapiens 2
	@mix merge ecoli 2
	@mix merge mouse 2
	@mix merge viruses 2

	@mix merge homosapiens 3
	@mix merge ecoli 3
	@mix merge mouse 3
	@mix merge viruses 3

	@mix merge homosapiens 4
	@mix merge ecoli 4
	@mix merge mouse 4
	@mix merge viruses 4
	
	@mix merge homosapiens 5
	@mix merge ecoli 5
	@mix merge mouse 5
	@mix merge viruses 5
