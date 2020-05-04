import os
import json
from collections import defaultdict
import numpy as np
import matplotlib.pyplot as plt


RESULT_DIRECTORY = 'results'
MAX_DURATION = 10
NUM_EXPERIMENTS = 8
LOG_SCALE = False
DURATIONS = [0.075, 0.125, 0.25, 0.375, 0.5, 0.75, 1.0, 1.5, 2.0, 4.0]


class CycleEntry:
    def __init__(self, experiment_index, duration, user_answers, right_answers):
        self.duration = duration
        self.experiment_index = experiment_index
        self.user_answers = user_answers
        self.right_answers = right_answers

    def right_answered(self):
        for user_answer, right_answer in zip(self.user_answers, self.right_answers):
            if user_answer != right_answer:
                return False
        return True


class Person:
    def __init__(self, cycle_entries):
        self.cycle_entries = cycle_entries

    @staticmethod
    def from_json(json):
        cycle_entries = []
        for entry in json:
            cycle_entry = CycleEntry(
                entry['experiment_index'],
                entry['duration'], 
                entry['user_answers'],
                entry['right_answers']
            )
            cycle_entries.append(cycle_entry)
        return Person(cycle_entries)

    def get_experiment_best_duration(self):
        best_experiment_durations = [MAX_DURATION] * NUM_EXPERIMENTS
        for cycle_entry in self.cycle_entries:
            if cycle_entry.right_answered():
                best_experiment_durations[cycle_entry.experiment_index] = min(best_experiment_durations[cycle_entry.experiment_index], cycle_entry.duration)

        return best_experiment_durations

    def get_experiment_indices(self):
        experiment_indices = set()
        for cycle_entry in self.cycle_entries:
            experiment_indices.add(cycle_entry.experiment_index)
        return experiment_indices


def load_persons():
    persons = []
    for result in os.listdir(RESULT_DIRECTORY):
        if result.endswith('.json'):
            with open(os.path.join(RESULT_DIRECTORY, result), 'r') as json_file:
                person = Person.from_json(json.load(json_file))
                persons.append(person)
    return persons


def plot(data, experiment_index):
    for d in DURATIONS:
        plt.axhline(y=d, xmin=0, xmax=8, color='lightgray', linestyle='--', linewidth=1.0)
    plt.axhline(y=0.25, xmin=0, xmax=8, color='c', linestyle='--')
    plt.axhline(y=0.0, xmin=0, xmax=8, color='black')
    # plt.axvline(x=0.0, ymin=0, ymax=4, color='black')
    if experiment_index is None:
        plt.boxplot(data, labels=list(map(lambda x: 'Exp. {}'.format(x+1), range(NUM_EXPERIMENTS))))
    else:
        plt.boxplot(data, labels=['Exp. {}'.format(experiment_index+1)])

    plt.ylabel('Anzeigedauer in Sekunden')
    plt.yticks(DURATIONS + [0.0, 3.0])
    if LOG_SCALE:
        plt.yscale('log')
    plt.show()


def plot_best_durations(persons):
    bdurations = []
    for person in persons:
        bdurations.append(person.get_experiment_best_duration())

    print('experiment median duration values: {}'.format(np.median(bdurations, axis=0)))

    data = np.array(bdurations)

    for i in range(data.shape[1]):
        plot(data[:,i], i)
    plot(data, None)


def main():
    persons = load_persons()
    plot_best_durations(persons)


if __name__ == '__main__':
    main()
