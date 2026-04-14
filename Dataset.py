import data_preparation_realData_suc as dataPrepare
from torch import Tensor
from typing import Tuple

class Dataset:

    def __init__(self, config, rat, region, test_fold, device, log=True):
        super(Dataset, self).__init__()

        self.rat = rat
        self.test_fold = test_fold
        self.region = region
        self.device = device

        data = dataPrepare.get_data(f'./data/extended_trial_data_{self.rat}.mat', config.DATA.SELECT_M1)
        # split and segment data
        data = dataPrepare.prepare_train_test(data, self.test_fold, log)
        data = dataPrepare.segment_all(data, config.MODEL.TIME_WINDOW,
                                       config.TRAIN.STEP_SIZE, config.TRAIN.STEP_SIZE_TEST)

        # get train and test
        if self.region == 'mPFC2M1':
            self.train_in = data['mPFC_train'].to(self.device)
            self.test_in = data['mPFC_test'].to(self.device)
            self.train_out = data['M1_train'].to(self.device)
            self.test_out = data['M1_test'].to(self.device)
        else:
            self.train_in = data[f'{self.region}_train'].to(self.device)
            self.test_in = data[f'{self.region}_test'].to(self.device)
            self.train_out = data[f'{self.region}_train'].to(self.device)
            self.test_out = data[f'{self.region}_test'].to(self.device)

        self.seq_len = self.train_in.size(0) - 1

        self.train_movements = data['movements_train']
        self.test_movements = data['movements_test']
        self.train_trial_no = data['trial_No_train']
        self.test_trial_no = data['trial_No_test']

        self.in_neuron_num = self.train_in.size(2)
        self.out_neuron_num = self.train_out.size(2)

# used in TC loss, Ziyi 260407
def get_mini_batch(segments: Tensor, bsz: int, indices: list, i: int, flatten_target: bool = True) \
        -> Tuple[Tensor, Tensor]:
    """
    Args:
        segments: Tensor, shape ``[seq_len, segment_num, neuron_num]``
        bsz: int, batch size
        indices: list, a list of shuffled indices
        i: int
        flatten_target: bool, whether to flatten target

    Returns:
        tuple (data, target), where data has shape ``[seq_len, batch_size, neuron_num]``
        and target has shape ``[seq_len * batch_size, neuron_num]``
    """
    segment_num = segments.size(1)
    neuron_num = segments.size(2)

    indices = indices[i:min(i + bsz, segment_num)]

    data = segments[0:-1, indices]
    target = segments[1:, indices]
    if flatten_target:
        target = target.permute(1, 0, 2).reshape(-1, neuron_num)
    return data, target
