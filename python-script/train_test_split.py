import os
import math
import pandas as pd


def read_csv_file(file_path: str) -> pd.DataFrame:
    """Reads a CSV file and returns a DataFrame."""
    return pd.read_csv(file_path)


def get_filename_from_path(file_path: str) -> str:
    """Extracts the file name from the given file path."""
    return os.path.basename(file_path)


def get_train_amount(num_lines: int) -> int:
    """Return an amount of data for the training set."""
    return math.ceil(num_lines * 0.8)


def save_row_to_txt(row: pd.Series, directory: str, index: int) -> None:
    """Saves a single row of a DataFrame to a .txt file."""
    file_path = os.path.join(directory, f"{index}.txt")
    with open(file_path, 'w') as file:
        file.write('\n'.join([str(item) for item in row]))


def save_dataframe_to_txt(df: pd.DataFrame, directory: str) -> None:
    """Saves each row of the DataFrame to separate .txt files."""
    if not os.path.exists(directory):
        os.makedirs(directory)
    for i, row in df.iterrows():
        save_row_to_txt(row, directory, i)


def train_test_split(file_path: str) -> None:
    """Splits the data into training (80%) and testing (20%) sets and saves them as .txt files."""
    df = read_csv_file(file_path)
    train_columns = get_train_amount(len(df))
    file_name = get_filename_from_path(file_path)
    base_name = file_name.split(".")[0]

    train_directory = f"./train/{base_name}"
    test_directory = f"./test/{base_name}"

    save_dataframe_to_txt(df.iloc[:train_columns, :1],
                          train_directory)  # Exclude labels (assumed to be in the first column)
    save_dataframe_to_txt(df.iloc[train_columns:, :1],
                          test_directory)  # Exclude labels (assumed to be in the first column)


def main():
    train_test_split("./dataset/FAKE.csv")
    train_test_split("./dataset/POSITIVE.csv")


if __name__ == "__main__":
    main()