import pandas as pd


def get_input_files(organisms, modality, kmer):
    base_dir = 'data/output'
    input_files = []
    for organism in organisms:
        input_files.append(f'{base_dir}/{organism}/{modality}/k{kmer}.csv')
        
    return input_files

def get_merged_data(input_files):
    frames = []
    for input_file in input_files:
        data = pd.read_csv(input_file)
        data['organism'] = input_file.split('/')[-3]
        frames.append(data)
                
    return pd.concat(frames, axis=0)