import pandas as pd


def main():
    organisms = ['ecoli', 'homosapiens', 'mouse', 'viruses']
    kmer_length = 2
    base_dir = 'data/output/merged'
    
    for organism in organisms:
        input_file = f'{base_dir}/{organism}_k{kmer_length}.csv'
        wordcount_df = pd.read_csv(input_file)

        wordcount_df = wordcount_df.sort_values(by='frequency', ascending=False)
        wordcount_df = wordcount_df[:5]
        
        print(wordcount_df)


if __name__ == '__main__':
    main()
