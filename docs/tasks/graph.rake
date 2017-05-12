require 'graphviz'

namespace :graph do
  task machines: :environment do
    [ImportMicroMachine, SyncMicroMachine].each do |klass|
      machine = klass.start(nil, nil)

      graph = GraphViz.new(:G, type: :digraph)
      nodes = machine.states.map { |state| graph.add_nodes(state) }

      transitions = machine.transitions_for.values.flat_map(&:to_a)

      transitions.each do |transition|
        from, to = transition.map { |id| nodes.find { |node| node.id == id } }
        graph.add_edges(from, to)
      end

      graph.output png: "docs/#{klass}_graph.png"
    end
  end
end
