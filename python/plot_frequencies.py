import argparse
import pandas as pd
import numpy as np
import plotly.graph_objects as go

from colors import Colors
from utils import get_input_files, get_merged_data


def main(args):
    organisms = ['homosapiens', 'mouse', 'ecoli', 'viruses']
    kmer = args.kmer
    modality = args.modality
    
    input_files = get_input_files(organisms, modality, kmer)
    wordcount_df = get_merged_data(input_files)
    
    wordcount_df['log_rank'] = np.log(wordcount_df['rank'])
    wordcount_df['log_count'] = np.log(wordcount_df['count'])

    wordcount_df = wordcount_df.drop(columns=['rank', 'count'])
    
    color_map = {
        'homosapiens': Colors.BLUE2,
        'mouse': Colors.RED2,
        'ecoli': Colors.GREEN2,
        'viruses': Colors.ORANGE2
    }
    
    figure = go.Figure()
    
    for organism in organisms:
        data = wordcount_df[wordcount_df['organism'] == organism]
        figure.add_trace(
            go.Scatter(
                x=data['log_rank'], 
                y=data['log_count'], 
                mode='lines', name=organism,
                line=dict(width=2, color=color_map[organism])
            )
        )
    
    figure.update_layout(
        xaxis_title=r'$log(rank)$',
        yaxis_title=r'$log(frequency)$',
        paper_bgcolor='rgba(0,0,0,0)',
        plot_bgcolor='rgba(0,0,0,0)',
        showlegend=True,
        
        xaxis=dict(
            showline=True,
            linecolor=Colors.BLUE1,
            linewidth=2,
            gridcolor=Colors.BLUE1,
            showgrid=True,
        ),
        yaxis=dict(
            showline=True,
            linecolor=Colors.BLUE1,
            linewidth=2,
            gridcolor=Colors.BLUE1,
            showgrid=True,
        )
    )
    
    #figure.show()
    figure.write_image(f"figures/k{kmer}/rank_vs_{modality}.png", format="png", engine="kaleido", scale=5)    

        
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Plot frequencies')
    
    parser.add_argument('--kmer', type=int, default=2, help='k-mer size')
    parser.add_argument('--modality', choices=['frequency', 'coverage'], type=str, default='frequency', help='Modality (coverage or frequency)')

    args = parser.parse_args()    
    main(args)
