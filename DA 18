# Importing Libraries
import pandas as pd
import numpy as np

# Importing Dataset
Train = pd.read_csv('Train_UWu5bXk.csv')
Test = pd.read_csv('Test_u94Q5KV.csv')

# Splitting into Training & Testing
X_train, y_train = Train.iloc[:, :-1].values, Train.iloc[:, -1].values

# Identifying Categorical Variables, NaN Values
print(Train.info())
print(Train.isnull().any())

# Categorical Variables Indexes:    0, 2, 4, 6, 8, 9, 10
# Missing Values in Indexes:        1, 8
# Deformed Values in Indexes:       2
def prepro(dataset):
    X_dataset = dataset.values
    # A. Imputing Missing Values
    from sklearn.preprocessing import Imputer
    impute = Imputer(missing_values='NaN', strategy='mean')
    column1 = X_dataset[:, 1].reshape(-1, 1)
    X_dataset[:, 1] = impute.fit_transform(column1).reshape(1, -1)

    # B. Deformed Values into Uniform Values
    X_dataset = pd.DataFrame(X_dataset)
    X_dataset.iloc[:, 2] = X_dataset.iloc[:, 2].map({'reg': 'Regular', 'LF': 'Low Fat', 'low fat': 'Low Fat',
                                'Low Fat': 'Low Fat', 'Regular': 'Regular'})
    X_dataset = X_dataset.values

    # Label Encoding for column2
    from sklearn.preprocessing import LabelEncoder, OneHotEncoder
    label_encoder_1 = LabelEncoder()
    X_dataset[:, 2] = label_encoder_1.fit_transform(X_dataset[:, 2])
    label_encoder_2 = LabelEncoder()
    X_dataset[:, 10] = label_encoder_2.fit_transform(X_dataset[:, 10])
    label_encoder_3 = LabelEncoder()
    X_dataset[:, 9] = label_encoder_2.fit_transform(X_dataset[:, 9])

    # C. Removal of unused Variables
    X_dataset = X_dataset[:, [1, 2, 3, 5, 7, 9, 10]]

    # D. Hot Encoding
    ohe_1 = OneHotEncoder(categorical_features=[5, 6])
    X_dataset = ohe_1.fit_transform(X_dataset).toarray()
    return X_dataset

# Machine: Regressor | Regressor: Linear
X_train = prepro(Train)

from sklearn.linear_model import LinearRegression
lin_reg = LinearRegression()
lin_reg.fit(X_train, y_train)
X_test = prepro(dataset=Test)
y_pred = lin_reg.predict(X_test)

X_df = pd.DataFrame(X_test)
y_df = pd.DataFrame(y_pred)
Headers = pd.DataFrame(Test.iloc[:, [0, 6]])

Result = pd.concat([Headers, X_df, y_df], axis=1, ignore_index=True)
Result = Result.rename(columns={0: 'Item Identifier', 1: 'Outlet Identifier', 14: 'Predicted Outlet Sales'})
Result.to_csv('07_BigMartSales_RESULTS.csv', index=False)
print('CHECK FOR: 07_BigMartSales_RESULTS.csv IN WORKING DIRECTORY')
