#!/usr/bin/env python
# coding: utf-8

# ### Importing Libraries

# In[4]:


# Importing the pandas library and giving it an alias 'pd'
import pandas as pd


# In[5]:


# Loading CSV and Excel files into DataFrames
df1 = pd.read_csv('population-2010-2019.csv')
df2 = pd.read_csv('population-2020-2029.csv')
df3 = pd.read_csv('population-2030-2040.csv')


# ### Data Inspection and Cleaning

# In[6]:


# Displaying the first five rows of df1 DataFrame
df1.head()


# In[7]:


#Replacing Header with Top Row
# To do this there are different ways here few
#df1.columns = df1.iloc[0]
#df1 = df1[1:]

# Rename columns using the values from the first row
df1.columns = df1.iloc[0]
# Drop the first row
df1 = df1.drop(df1.index[0])
df1


# In[8]:


# Displaying the data types of columns in df1 DataFrame
df1.dtypes


# In[9]:


# Displaying the content of df2 DataFrames
df2


# In[10]:


# Displaying the data types of columns in df2 DataFrame
df2.dtypes


# In[11]:


# Displaying the content of df3 DataFrames
df3


# In[12]:


# Displaying the data types of columns in df3 DataFrame
df3.dtypes


# In[13]:


# Removing duplicate values from the 'Agegrp' column in df3 DataFrame
df3['AgeGrp'].drop_duplicates()


# In[19]:


# Removing duplicate values from the 'LocID' column in df3 DataFrame
df3['LocID'].drop_duplicates()


# In[20]:


# Dropping rows with missing values in df3 DataFrame
df3 = df3.dropna()
df3


# In[21]:


df3.dtypes


# In[22]:


# Changing the data type of selected columns to 'object' in df3 DataFrame
df3[['LocID','Time','AgeGrpStart']] = df3[['LocID','Time','AgeGrpStart']].dropna().astype(object)


# In[23]:


df3[['AgeGrpSpan','PopFemale','PopTotal']] = df3[['AgeGrpSpan','PopFemale','PopTotal']].dropna().astype(object)


# In[24]:


df3.dtypes


# ### Data Combination

# In[58]:


# concatenate the DataFrames # Combining all three columns
df = pd.concat([df1, df2, df3])


# In[59]:


df


# ### Data Cleaning and Transformation

# In[60]:


# drop the column 
df.pop('AgeGrpSpan')
df.pop('AgeGrpStart')
df.pop('PopTotal')


# In[61]:


df


# In[62]:


# Displaying the data types of columns in df DataFrame after removing the columns
df.dtypes


# In[63]:


# Removing duplicate values from the df["AgeGrp"] column in df DataFrame
df["AgeGrp"].drop_duplicates()


# In[64]:


#Replacing irrelevant values in df["AgeGrp"]
df['AgeGrp'] = df['AgeGrp'].replace({'05. Sep': '5-9','05-Sep': '5-9','Oct-14': '10-14','Okt 14': '10-14','905. Sep9': '95-99','100+': '100-100'})


# In[65]:


#Checking the Replaced Values
df["AgeGrp"].drop_duplicates()


# In[66]:


#Removing duplicates
df["Time"].drop_duplicates()


# In[67]:


#Removing the rows containing the value NO DATA
df = df[df["Time"] != "NO DATA"]


# In[68]:


df = df.dropna(subset=['Time'])


# In[69]:


df["Time"].drop_duplicates()


# In[70]:


#convert 'Time' and 'LocID' columns to integers.
df['Time'] = df['Time'].astype(int)
df['LocID'] = df['LocID'].dropna()
df['LocID'] = df['LocID'].astype(int)


# In[71]:


#Checking data type after converting the data type
df.dtypes


# In[72]:


df


# In[73]:


# Removing Duplicates
df['AgeGrp'].drop_duplicates()


# In[74]:


#Splitting the column Agemin,Agemax
df[['Agemin','Agemax']] = df['AgeGrp'].str.split('-',expand=True)
df


# In[75]:


#Changing Data type object to int
df['Agemin'] = df['Agemin'].astype(int)
df['Agemax'] = df['Agemax'].astype(int)
df.dtypes


# In[76]:


#Replacing irrelavant Values
df['PopMale'] = df['PopMale'].replace({'ERROR_6.246': '6.246'})


# In[77]:


#we cant change the data type object to int because value in the popmale and popfemale is decimal so first converting object to float
df['PopMale'] = df['PopMale'].astype(float)
df['PopFemale'] = df['PopFemale'].astype(float)
df.dtypes


# In[78]:


#change data type float to int 
df['PopMale'] = df['PopMale'].astype(int)
df['PopFemale'] = df['PopFemale'].astype(int)
df.dtypes


# In[79]:


df


# In[80]:


#Renaming column names in Pandas:
df = df.rename(columns={'LocID': 'Location_ID','Time': 'Year','AgeGrp': 'Age_Group',
                        'PopMale': 'Male','PopFemale': 'Female',
                        'Agemin': 'Age_Min','Agemax': 'Age_Max'})
df


# In[81]:


#Extracting the column names
df.columns


# In[82]:


#Re-arranging the column
df = df[['Location_ID','Location','Year','Age_Group','Age_Min','Age_Max','Male','Female']]
df


# In[83]:


# Creating function to add category column 
def category(Age_Max):
    if Age_Max <= 4:
        return 'Baby'
    elif Age_Max <= 14:
        return 'Child'
    elif Age_Max <= 24:
        return 'Teenager'
    elif Age_Max <= 34:
        return 'Young_Adult'
    elif Age_Max <= 59:
        return 'Adult'
    else:
        return 'Senior'


# In[84]:


#Creating conditional Column using above function
df['Age_Category'] = df['Age_Max'].apply(category)
df['Age_Category']


# In[85]:


df.head()


# In[86]:


df.dtypes


# ### Importing and Merging Additional Data

# In[102]:


# Importing country code data 
df_cc = pd.read_csv('Population-Country_Code.csv')
df_cc


# In[103]:


#Renaming the Column Names
df_cc = df_cc.rename(columns={'Country_Code': 'Region_ID'})
df_cc


# In[104]:


#Dropping Duplicates
df_cc['Region_ID'].drop_duplicates()
# Replace NaN with 'NA' in the 'Region_ID' column
df_cc['Region_ID'] = df_cc['Region_ID'].fillna('NA')
df_cc['Region_ID'].drop_duplicates()


# In[105]:


# Importing Region Names
df_rn = pd.read_csv('Population-RN.csv')
df_rn


# In[106]:


#Region Names
df_rn = df_rn.rename(columns={'Custom': 'Region_Name','Region ID':'Region_ID'})
# Replace NaN with 'NA' in the 'Region_ID' column
df_rn['Region_ID'] = df_rn['Region_ID'].fillna('NA')
df_rn


# In[107]:


# Combing Region Names with country_code data frame
df_cr= df_cc.merge(df_rn, on='Region_ID')
df_cr


# In[108]:


df_cr['Region_ID'].drop_duplicates()


# In[109]:


df_cr.dtypes


# In[110]:


df_cr = df_cr.dropna()
df_cr


# In[111]:


#change data type float to int 
df_cr['Location_ID'] = df_cr['Location_ID'].astype(int)


# In[112]:


#Dropping columns
df_cr.pop('Location')
df_cr


# In[116]:


df


# In[118]:


# Merging df with df_cr on Location_ID
merged_df = pd.merge(df, df_cr[['Region_ID', 'Location_ID','Region_Name']], on='Location_ID', how='left')


# In[119]:


df = merged_df 
df.head()


# In[120]:


# Specify the new order of columns
new_column_order = ['Location_ID', 'Location', 'Region_ID', 'Region_Name', 'Year', 'Age_Group', 'Age_Min', 'Age_Max', 'Age_Category', 'Male', 'Female']

# Reorder the DataFrame
df = df[new_column_order]


# In[121]:


df


# In[122]:


df.head()


# In[123]:


#export the cleaned data
#df.to_csv('final_data.csv', index=False)


# ### Data Visualization and Analysis

# In[124]:


#Importing Libraries for Data Visualization
import matplotlib.pyplot as plt
import seaborn as sns


# In[125]:


# Data manipulation
# Calculate total population
df['Total_Population'] = df['Male'] + df['Female']


# In[126]:


df


# In[127]:


# Data visualization
# Bar plot of total population by location
plt.figure(figsize=(10, 6))
sns.barplot(x='Region_ID', y='Total_Population', data=df)
plt.title('Total Population by Region')
plt.xlabel('Region_ID') #X Lable Name
plt.ylabel('Total Population') #Y lable Name
# plt.xticks(rotation=45) #Rotating the region names 
plt.show()


# In[128]:


# Summary statistics
df.describe()


# In[129]:


# Correlation between Male and Female populations
correlation = df['Male'].corr(df['Female'])
print("Correlation between Male and Female populations:", correlation)


# In[130]:


# Grouping data by year and summing up populations
yearly_population = df.groupby('Year')[['Male', 'Female']].sum().reset_index()

# Melt the DataFrame to have 'Year', 'Population Type', and 'Population' columns
yearly_population_melted = pd.melt(yearly_population, id_vars=['Year'], var_name='Population_Type', value_name='Population')

# Plotting the time series graph
plt.figure(figsize=(10, 6))
sns.lineplot(data=yearly_population_melted, x='Year', y='Population', hue='Population_Type')
plt.title('Population Over Time')
plt.xlabel('Year')
plt.ylabel('Population')
plt.legend(title='Population Type')
plt.grid(True)
plt.show()


# In[131]:


# Analysis of population by age category, male and female population, and total population
age_category_analysis = df.groupby('Age_Category')[['Male', 'Female', 'Total_Population']].sum().reset_index()

# Plotting the analysis
plt.figure(figsize=(10, 6))

# Bar plot for total population by age category
plt.subplot(1, 2, 1)
sns.barplot(data=age_category_analysis, x='Age_Category', y='Total_Population', palette='viridis')
plt.title('Total Population by Age Category')
plt.xlabel('Age Category')
plt.ylabel('Total Population')

# Line plot for male and female population by age category
plt.subplot(1, 2, 2)
sns.lineplot(data=age_category_analysis, x='Age_Category', y='Male', label='Male', marker='o')
sns.lineplot(data=age_category_analysis, x='Age_Category', y='Female', label='Female', marker='o')
plt.title('Male and Female Population by Age Category')
plt.xlabel('Age Category')
plt.ylabel('Population')
plt.legend()

plt.tight_layout()
plt.show()


# In[132]:


# Data manipulation
# Group by region and age category
region_age_analysis = df.groupby(['Region_Name', 'Age_Category'])[['Male', 'Female', 'Total_Population']].sum().reset_index()

# Plotting the analysis

# Set the style
sns.set(style="whitegrid")

# Create a figure with multiple subplots
plt.figure(figsize=(14, 8))

# Total population by region and age category
plt.subplot(2, 1, 1)
sns.barplot(data=region_age_analysis, x='Region_Name', y='Total_Population', hue='Age_Category', palette='viridis')
plt.title('Total Population by Region and Age Category')
plt.xlabel('Region')
plt.ylabel('Total Population')
plt.legend(title='Age Category', bbox_to_anchor=(1.05, 1), loc='upper left')

# Male vs Female population by region and age category
plt.subplot(2, 1, 2)
sns.lineplot(data=region_age_analysis, x='Region_Name', y='Male', hue='Age_Category', marker='o', palette='Blues', label='Male')
sns.lineplot(data=region_age_analysis, x='Region_Name', y='Female', hue='Age_Category', marker='o', palette='Reds', label='Female', linestyle='--')
plt.title('Male and Female Population by Region and Age Category')
plt.xlabel('Region')
plt.ylabel('Population')
plt.legend(title='Age Category', bbox_to_anchor=(1.05, 1), loc='upper left')

plt.tight_layout()
plt.show()


# In[134]:


# Split the dataset into two parts
df_part1 = df.iloc[:len(df)//2]
df_part2 = df.iloc[len(df)//2:]

def analyze_part(df_part, part_name):
    # Data manipulation
    # Group by region and age category
    region_age_analysis = df_part.groupby(['Region_Name', 'Age_Category'])[['Male', 'Female', 'Total_Population']].sum().reset_index()

    # Plotting the analysis

    # Set the style
    sns.set(style="whitegrid")

    # Create a figure with multiple subplots
    plt.figure(figsize=(14, 8))

    # Total population by region and age category
    plt.subplot(2, 1, 1)
    sns.barplot(data=region_age_analysis, x='Region_Name', y='Total_Population', hue='Age_Category', palette='viridis')
    plt.title(f'Total Population by Region and Age Category ({part_name})')
    plt.xlabel('Region')
    plt.ylabel('Total Population')
    plt.legend(title='Age Category', bbox_to_anchor=(1.05, 1), loc='upper left')

    # Male vs Female population by region and age category
    plt.subplot(2, 1, 2)
    sns.lineplot(data=region_age_analysis, x='Region_Name', y='Male', hue='Age_Category', marker='o', palette='Blues', label='Male')
    sns.lineplot(data=region_age_analysis, x='Region_Name', y='Female', hue='Age_Category', marker='o', palette='Reds', label='Female', linestyle='--')
    plt.title(f'Male and Female Population by Region and Age Category ({part_name})')
    plt.xlabel('Region')
    plt.ylabel('Population')
    plt.legend(title='Age Category', bbox_to_anchor=(1.05, 1), loc='upper left')

    plt.tight_layout()
    plt.show()

    # Summary statistics
    summary_stats = region_age_analysis.describe()
    print(f"Summary statistics for {part_name}:\n", summary_stats)

    # Correlation between Male and Female populations
    correlation = region_age_analysis[['Male', 'Female']].corr()
    print(f"Correlation between Male and Female populations for {part_name}:\n", correlation)

# Analyze the first part
analyze_part(df_part1, "Part 1")

# Analyze the second part
analyze_part(df_part2, "Part 2")


# In[ ]:




