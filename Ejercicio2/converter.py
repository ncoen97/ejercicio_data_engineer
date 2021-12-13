import pandas as pd
import pandera as pa
import sys

# run: python Ejercicio2.py input.tsv output.csv


def query_yes_no(question):
    valid = {"yes": True, "y": True, "ye": True, "no": False, "n": False}
    prompt = " [y/n] "

    while True:
        print(question + prompt)
        choice = input().lower()
        if choice in valid:
            return valid[choice]
        else:
            print("Please respond with 'yes' or 'no'")


def convert(df, output):
    # convert to csv and save
    df.to_csv(output, index=False, sep='|', na_rep='Null')
    print("File converted successfully:", output)


def validate_schema(df):
    try:
        schema = pa.DataFrameSchema({
            "id": pa.Column(int, unique=True),
            "first_name": pa.Column(str, nullable=True),
            "last_name": pa.Column(str, nullable=True),
            "account_number": pa.Column(int, nullable=True),
            "email": pa.Column(str, nullable=True)
        })
        schema(df)

    except pa.errors.SchemaError as err:
        wants_to_continue = query_yes_no(
            f'The input data is not valid: {err}.\nDo you want to convert anyways?')
        if not wants_to_continue:
            raise err


if __name__ == "__main__":

    if len(sys.argv) < 3:
        print("Please indicate file input and output")
        sys.exit(-1)

    # params
    filename = sys.argv[1]
    output = sys.argv[2]

    # read tsv
    try:
        # convert to csv and save
        df = pd.read_table(filename, sep='\t', encoding='UTF-16LE', header=0, on_bad_lines='warn')

        validate_schema(df)

        convert(df, output=output)

    except Exception as ex:
        print("Error:", ex)
