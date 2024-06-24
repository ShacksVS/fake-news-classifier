import sys
import pandas as pd
import os
import argparse

from utils import read_csv_file, save_dataframe_to_csv


def add_data_to_csv(new_file_path: str, existing_file_path: str) -> None:
    """Reads new data from a CSV file and appends it to an existing CSV file."""
    first_df = read_csv_file(new_file_path)
    main_df = read_csv_file(existing_file_path)

    # Concatenate the two DataFrames
    combined_df = pd.concat([main_df, first_df], ignore_index=True)

    save_dataframe_to_csv(combined_df, existing_file_path)

    print(f"Data from {new_file_path} has been added to {existing_file_path}.")


def main() -> None:
    parser = argparse.ArgumentParser(description="Add data from one CSV file to another.")
    parser.add_argument("new_file", type=str, help="Path to the new CSV file.")
    parser.add_argument("existing_file", type=str, help="Path to the existing CSV file to be updated.")

    args = parser.parse_args()

    if not os.path.exists(args.new_file):
        print(f"Error: The file {args.new_file} does not exist.")
        sys.exit(1)

    if not os.path.exists(args.existing_file):
        print(f"Error: The file {args.existing_file} does not exist.")
        sys.exit(1)

    add_data_to_csv(args.new_file, args.existing_file)


if __name__ == "__main__":
    # python add_data.py "./new/NEW_FAKE.csv" "./dataset/FAKE.csv"
    main()
