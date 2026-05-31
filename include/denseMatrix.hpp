#pragma once
#include <vector>
#include <cstddef>

class DenseMatrix
{
public:
    DenseMatrix() = default;

    DenseMatrix( int rowCount, int columnCount )
        : rowCount_(rowCount), columnCount_(columnCount), data_(rowCount * columnCount, 0.0f)
    {
    }

    inline int getRowCount() const
    {
        return rowCount_;
    }
    inline int getColumnCount() const
    {
        return columnCount_;
    }

    inline float getValue( int row, int column ) const
    {
        return data_[ row * columnCount_ + column ];
    }
    inline void setValue( int row, int column, float value )
    {
        data_[ row * columnCount_ + column ] = value;
    }

    inline float* getRawData()
    {
        return data_.data();
    }
    inline const float* getRawData() const
    {
        return data_.data();
    }

    inline std::vector<float>& getData()
    {
        return data_;
    }
    inline const std::vector<float>& getData() const
    {
        return data_;
    }

    inline size_t getElementCount() const
    {
        return data_.size();
    }

    inline size_t getSizeInBytes() const
    {
        return data_.size() * sizeof(float);
    }

    inline bool isSquare() const
    {
        return rowCount_ == columnCount_;
    }

private:

    int rowCount_ = 0;
    int columnCount_ = 0;
    std::vector<float> data_;
};
