import argparse
import pandas as pd
import plotly.express as px

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
        "num_rare_words": [],
        "ratio": []
    }
    
    for organism in organisms:
        organism_data = wordcount_df[wordcount_df['organism'] == organism]
        num_words = organism_data.shape[0]
        num_rare_words = organism_data[organism_data['count'] == 1].shape[0]
        
        data["organism"].append(organism)
        data["num_words"].append(num_words)
        data["num_rare_words"].append(num_rare_words)
        data["ratio"].append((num_rare_words / num_words) * 100)
        
    data = pd.DataFrame(data)
    
    fig = px.bar(
        data,
        x="organism",
        y="ratio",
        labels={"organism": "Organism", "ratio": "Ratio in %"},
        color=[Colors.BLUE2] * len(organisms),
        color_discrete_sequence=[Colors.BLUE2],
        text=data["ratio"].apply(lambda x: f"{x:.2f}"),
    )
    
    fig.update_layout(
        xaxis=dict(tickmode="linear"),
        yaxis=dict(range=[0, 100]),
        paper_bgcolor='rgba(0,0,0,0)',
        plot_bgcolor='rgba(0,0,0,0)',
        font=dict(color="black"),
        showlegend=False
    )

    fig.write_image(f"figures/k{kmer}/rare_words_distribution.png", format="png", engine="kaleido", scale=5)



if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    
    parser.add_argument('--kmer', type=int, required=True)
    
    args = parser.parse_args()
    
    main(args)