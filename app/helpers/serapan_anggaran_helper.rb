module SerapanAnggaranHelper
  # rubocop:disable Metrics
  def growth_average(data)
    return if data.any? { |_, v| v.nil? }

    # data => { 2020 => 123,
    #           2021 => 124,
    #           2022 => 125,
    #           2023 => 126,
    #           2024 => 127
    #           }
    # Extract years with non-zero values
    filtered_data = data.reject { |_, value| value.zero? }

    years = filtered_data.keys.sort

    growth_rates = years.each_cons(2).map do |prev_year, curr_year|
      prev_value = data[prev_year]
      curr_value = data[curr_year]

      # Skip if the previous value is zero to avoid division by zero
      next if prev_value.zero?

      ((curr_value - prev_value).to_f / prev_value * 100).round(2)
    end

    return 0 unless growth_rates.any?

    growth = (growth_rates.sum / growth_rates.size.to_f).round(2)
    "#{growth}%"
  end

  def rasio_serapan_anggaran(anggaran, realisasi)
    return 0 if anggaran.nil? || realisasi.nil?

    rasio = ((realisasi / anggaran) * 100).round(2)

    "#{rasio}%"
  end
end
