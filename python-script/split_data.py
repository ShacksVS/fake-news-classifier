import pandas as pd

import os

from utils import read_csv_file, save_dataframe_to_csv

PATH_TO_CSV_FILE = "./archive/data_set_4.csv"
PATH_TO_SAVE_CSV = "./dataset/"
POSITIVE_CSV_FILENAME = "POSITIVE.csv"
FAKE_CSV_FILENAME = "FAKE.csv"


def split_dataframe(df: pd.DataFrame) -> tuple[pd.DataFrame, pd.DataFrame]:
    """Splits the DataFrame into positive and fake news DataFrames based on the Label."""

    df = df[['Text', 'Label']]

    positive_rows = []
    fake_rows = []

    for index, row in df.iterrows():
        if row['Label']:
            positive_rows.append(row)
        else:
            fake_rows.append(row)

    positive_df = pd.DataFrame(positive_rows, columns=df.columns)
    fake_df = pd.DataFrame(fake_rows, columns=df.columns)

    return positive_df, fake_df


def main() -> None:
    df = read_csv_file(PATH_TO_CSV_FILE)

    # Split the DataFrame into positive and fake news DataFrames
    positive_df, fake_df = split_dataframe(df)

    # Print the counts of positive and fake news
    print(f"Positive news: {len(positive_df)}\nFake news: {len(fake_df)}")

    # Save the DataFrames to CSV files
    save_dataframe_to_csv(positive_df, os.path.join(PATH_TO_SAVE_CSV, POSITIVE_CSV_FILENAME))
    save_dataframe_to_csv(fake_df, os.path.join(PATH_TO_SAVE_CSV, FAKE_CSV_FILENAME))

    print("DataFrames have been written to CSV files.")


if __name__ == "__main__":
    main()
