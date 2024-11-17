from sklearn.model_selection import KFold
from sklearn.metrics import mean_absolute_error
import numpy as np


def cross_validation(data, graph, weights, K=10):
    kf = KFold(n_splits=10, shuffle=True, random_state=42)

    mae_scores = []
    relative_errors = []

    for train_index, test_index in kf.split(data):
        train_data, test_data = data.iloc[train_index], data.iloc[test_index]

        users_data = train_data[['user_id', 'age']].set_index('user_id').to_dict()['age']
        communities_data = get_community_data(train_data)

        graph_data = create_graph(train_data)

        # Распространение меток на сообщества и пользователей
        model = build_model(users_data)
        label_spread = spread_labels_communities(graph_data, communities_data, 'Modelmax')
        updated_users_data = spread_labels_users(graph_data, users_data, label_spread, weights)

        # Оценка качества на тестовой выборке
        test_users_data = test_data[['user_id', 'age']].set_index('user_id').to_dict()['age']

        # Рассчитываем MAE и относительную ошибку
        for user_id, true_age in test_users_data.items():
            if user_id in updated_users_data:
                predicted_age = updated_users_data[user_id]
                mae = abs(true_age - predicted_age)
                relative_error = mae / true_age

                mae_scores.append(mae)
                relative_errors.append(relative_error)

    avg_mae = np.mean(mae_scores)
    avg_relative_error = np.mean(relative_errors)

    return avg_mae, avg_relative_error


# Пример генерации данных
import pandas as pd

# Пример тестовых данных
data = pd.DataFrame({
    'user_id': [1, 2, 3, 4, 5, 6],
    'age': [25, 30, 23, 40, 35, 22],
    'friend_count': [12, 15, 20, 10, 18, 30],
    'community_count': [3, 4, 5, 2, 6, 7]
})

# Пример графа (фейковые данные)
graph = {
    'friends': {
        1: [2, 3],
        2: [1, 4],
        3: [1, 4],
        4: [2, 3],
        5: [6],
        6: [5]
    },
    'subscriptions': {
        1: ['A'],
        2: ['B'],
        3: ['A'],
        4: ['B'],
        5: ['A'],
        6: ['B']
    }
}

# Пример весов
weights = {
    'WUser': 0.7,
    'WComm': 0.3,
}

# Тестирование
mae, relative_error = cross_validation(data, graph, weights)

print(f"Средняя абсолютная ошибка (MAE): {mae}")
print(f"Средняя относительная ошибка: {relative_error}")
