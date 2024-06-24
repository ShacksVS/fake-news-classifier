import pandas as pd


def read_csv_file(path: str) -> pd.DataFrame:
    """Reads a CSV file and returns a DataFrame."""
    return pd.read_csv(path)


def save_dataframe_to_csv(df: pd.DataFrame, path: str) -> None:
    """Saves the DataFrame to a CSV file."""
    df.to_csv(path, index=False)


def get_filename_from_path(file_path: str) -> str:
    """Returns a file name from a given path."""
    components = file_path.split("/")
    return components[len(components) - 1]
