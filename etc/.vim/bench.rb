require "benchmark"

label_width = 10
times = 100
Benchmark.bm label_width do |r|
  r.report "sin" do
    times.times do
      Math.sin(1)
    end
  end
  r.report "cos" do
    times.times do
      Math.cos(1)
    end
  end
end

