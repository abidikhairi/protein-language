import argparse
import plotly.express as px
import pandas as pd

from colors import Colors
from utils import get_input_files, get_merged_data

def main(args):
    kmer = args.kmer
    organisms = ['homosapiens', 'mouse', 'ecoli', 'viruses']
    
    input_files = get_input_files(organisms, 'coverage', kmer)
    wordcount_df = get_merged_data(input_files)
    
    data = {
        "organism": [],
        "num_words": [],
        "num_found_words": [],
        "ratio": [],
        "missing_words_ratio": []
    }
    
    for organism in organisms:
        organism_data = wordcount_df[wordcount_df['organism'] == organism]
        num_words = 22 ** kmer
        num_found_words = organism_data[organism_data['count'] > 0].shape[0]
        
        data["organism"].append(organism)
        data["num_words"].append(num_words)
        data["num_found_words"].append(num_found_words)
        data["ratio"].append((num_found_words / num_words) * 100)
        data['missing_words_ratio'].append((1 - num_found_words / num_words) * 100)
    
    data = pd.DataFrame(data)
    
    fig = px.bar(
        data,
        x="organism",
        y="missing_words_ratio",
        labels={"organism": "Organism", "missing_words_ratio": "Missing Words Ratio in %"},
        color=[Colors.BLUE2] * len(organisms),
        color_discrete_sequence=[Colors.BLUE2],
        text=data["missing_words_ratio"].apply(lambda x: f"{x:.2f}"),
    )
    
    fig.update_layout(
        xaxis=dict(tickmode="linear"),
        yaxis=dict(range=[0, 100]),
        paper_bgcolor='rgba(0,0,0,0)',
        plot_bgcolor='rgba(0,0,0,0)',
        font=dict(color="black"),
        showlegend=False
    )

    fig.write_image(f"figures/k{kmer}/missing_words_distribution.png", format="png", engine="kaleido", scale=5)
    data.to_csv(f"data/output/k{kmer}_missing_words_distribution.csv", index=False)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Count missing words')

    parser.add_argument('--kmer', type=int, required=True)

    args = parser.parse_args()
    
    main(args)
