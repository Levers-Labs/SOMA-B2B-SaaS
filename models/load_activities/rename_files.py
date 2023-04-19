import os
import glob

def rename_files():
    files_to_rename = glob.glob("visitor_*")
    for filename in files_to_rename:
        new_filename = filename.replace("visitor_", "person_")
        os.rename(filename, new_filename)
        print(f"Renamed '{filename}' to '{new_filename}'")

if __name__ == "__main__":
    rename_files()
