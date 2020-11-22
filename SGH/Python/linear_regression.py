import fire
import numpy as np
import pandas as pd


np.random.seed(15)


def encode_categorical_variables(dataset: pd.DataFrame) -> np.ndarray:

    # drop dependent variable
    dataset = dataset.drop(dataset.columns[-1], axis=1)

    # separate numeric and categorical features
    categorical = dataset.select_dtypes(include=['O'])
    numeric = dataset.select_dtypes(np.number)

    encoded_categories = pd.DataFrame()

    for column in categorical.columns.unique():
        # since it's required to "drop one of the resulting variables",
        # I'll just drop the last category of each categorical variable
        for category in list(categorical[column].unique())[:-1]:
            new_colname = column + '_' + category
            encoded_categories[new_colname] = np.where(
                categorical[column] == category, 1, 0)

    output_dataset = pd.concat([numeric, encoded_categories], axis=1)
    output_dataset = np.array(output_dataset)

    return output_dataset


def standardize_features(x: np.ndarray) -> np.ndarray:
    for feature in range(x.shape[1]):
        x[:, feature] = (x[:, feature] - np.mean(x[:, feature])
                         ) / np.std(x[:, feature])

    return x


class LinearRegressionWithGradientUpdate:

    def __init__(self) -> None:
        self.theta1 = None
        self.theta2 = None

    def _init_weights(self, features_count: int) -> None:
        intercept_shape = 1

        self.theta1 = np.random.randn(features_count)
        self.theta2 = np.random.randn(intercept_shape)

    def predict(self, x: np.ndarray) -> np.ndarray:
        y_pred = np.dot(self.theta1, x.T) + self.theta2

        return y_pred

    @staticmethod
    def mse(y_true: np.ndarray, y_pred: np.ndarray) -> float:
        mse = float(np.sum((y_true - y_pred) ** 2) / y_true.shape[0])

        return mse

    @staticmethod
    def mae(y_true: np.ndarray, y_pred: np.ndarray) -> float:
        mae = float(np.sum(abs(y_true - y_pred)) / y_true.shape[0])

        return mae

    @staticmethod
    def _d_theta1(x: np.ndarray, y_true: np.ndarray, y_pred: np.ndarray) -> np.ndarray:
        _d_theta1 = np.array(
            [(-2 * np.dot(x[:, col], (y_true - y_pred)) / x.shape[0]) for col in range(x.shape[1])])

        return _d_theta1

    @staticmethod
    def _d_theta2(x: np.ndarray, y_true: np.ndarray, y_pred: np.ndarray) -> np.ndarray:
        _d_theta2 = (-2 / x.shape[0]) * sum(y_true - y_pred)

        return _d_theta2

    def _update_params(self, d_theta1: np.ndarray, d_theta2: np.ndarray,
                       learning_rate: float) -> None:
        self.theta1 -= learning_rate * d_theta1
        self.theta2 -= learning_rate * d_theta2

    def fit(self, x: np.ndarray, y: np.ndarray,
            epochs: int = 1000, learning_rate: float = 0.0001,
            verbose: bool = False) -> None:

        self._init_weights(x.shape[-1])
        for epoch in range(epochs):
            y_pred = self.predict(x)
            d_theta1 = self._d_theta1(x, y, y_pred)
            d_theta2 = self._d_theta2(x, y, y_pred)
            self._update_params(d_theta1, d_theta2,
                                learning_rate=learning_rate)
            if verbose:
                mse = self.mse(y, y_pred)
                mae = self.mae(y, y_pred)
                print('epoch: {},\n MSE: {},\n MAE: {}\n'
                      .format(epoch, mse, mae), end='\r')


def main(dataset_path='dataset.csv'):
    data = pd.read_csv(dataset_path)
    y_true = data['charges'].values

    # standardize dependent variable
    y_true = (y_true - np.mean(y_true)) / np.std(y_true)

    linear_regression_model = LinearRegressionWithGradientUpdate()
    features = encode_categorical_variables(data)
    standardized_features = standardize_features(features)

    linear_regression_model.fit(x=standardized_features, y=y_true,
                                verbose=True)


if __name__ == "__main__":
    fire.Fire(main)
